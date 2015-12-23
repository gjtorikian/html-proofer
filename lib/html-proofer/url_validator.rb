require 'typhoeus'
require 'uri'
require_relative './utils'
require_relative './cache'

class HTMLProofer
  class UrlValidator
    include HTMLProofer::Utils

    attr_accessor :logger, :external_urls, :iterable_external_urls, :hydra

    def initialize(logger, external_urls, options, typhoeus_opts, hydra_opts)
      @logger = logger
      @external_urls = external_urls
      @iterable_external_urls = {}
      @failed_tests = []
      @options = options
      @hydra = Typhoeus::Hydra.new(hydra_opts)
      @typhoeus_opts = typhoeus_opts
      @external_domain_paths_with_queries = {}
      @cache = Cache.new(@logger, @options[:cache])
    end

    def run
      @iterable_external_urls = remove_query_values

      if @cache.exists && @cache.load
        cache_count = @cache.cache_log.length
        cache_text = pluralize(cache_count, 'link', 'links')

        logger.log :info, :blue, "Found #{cache_text} in the cache..."

        urls_to_check = @cache.detect_url_changes(@iterable_external_urls)

        @cache.cache_log.each_pair do |url, cache|
          if @cache.within_timeframe?(cache['time'])
            next if cache['message'].empty? # these were successes to skip
            urls_to_check[url] = cache['filenames'] # these are failures to retry
          else
            urls_to_check[url] = cache['filenames'] # pass or fail, recheck expired links
          end
        end

        external_link_checker(urls_to_check)
      else
        external_link_checker(@iterable_external_urls)
      end

      @cache.write
      @failed_tests
    end

    def remove_query_values
      return nil if @external_urls.nil?
      iterable_external_urls = @external_urls.dup
      @external_urls.keys.each do |url|
        uri = begin
                Addressable::URI.parse(url)
              rescue URI::Error, Addressable::URI::InvalidURIError
                @logger.log :error, :red, "#{url} is an invalid URL"
                nil
              end
        next if uri.nil? || uri.query.nil?
        iterable_external_urls.delete(url) unless new_url_query_values?(uri)
      end
      iterable_external_urls
    end

    # remember queries we've seen, ignore future ones
    def new_url_query_values?(uri)
      queries = uri.query_values.keys.join('-')
      domain_path = extract_domain_path(uri)
      if @external_domain_paths_with_queries[domain_path].nil?
        @external_domain_paths_with_queries[domain_path] = [queries]
        true
      elsif !@external_domain_paths_with_queries[domain_path].include?(queries)
        @external_domain_paths_with_queries[domain_path] << queries
        true
      else
        false
      end
    end

    def extract_domain_path(uri)
      uri.host + uri.path
    end

    # Proofer runs faster if we pull out all the external URLs and run the checks
    # at the end. Otherwise, we're halting the consuming process for every file during
    # the check_directory_of_files process.
    #
    # In addition, sorting the list lets libcurl keep connections to the same hosts alive.
    #
    # Finally, we'll first make a HEAD request, rather than GETing all the contents.
    # If the HEAD fails, we'll fall back to GET, as some servers are not configured
    # for HEAD. If we've decided to check for hashes, we must do a GET--HEAD is
    # not an option.
    def external_link_checker(external_urls)
      external_urls = Hash[external_urls.sort]

      count = external_urls.length
      check_text = pluralize(count, 'external link', 'external links')
      logger.log :info, :blue, "Checking #{check_text}..."

      Ethon.logger = logger # log from Typhoeus/Ethon

      url_processor(external_urls)

      logger.log :debug, :yellow, "Running requests for:"
      logger.log :debug, :yellow, "###\n" + external_urls.keys.join("\n") + "\n###"

      hydra.run
    end

    def url_processor(external_urls)
      external_urls.each_pair do |href, filenames|
        href = begin
                 clean_url(href)
               rescue URI::Error, Addressable::URI::InvalidURIError
                 add_external_issue(filenames, "#{href} is an invalid URL")
                 next
               end

        if hash?(href) && @options[:check_external_hash]
          queue_request(:get, href, filenames)
        else
          queue_request(:head, href, filenames)
        end
      end
    end

    def clean_url(href)
      Addressable::URI.parse(href).normalize
    end

    def queue_request(method, href, filenames)
      request = Typhoeus::Request.new(href, @typhoeus_opts.merge({ :method => method }))
      request.on_complete { |response| response_handler(response, filenames) }
      hydra.queue request
    end

    def response_handler(response, filenames)
      effective_url = response.options[:effective_url]
      href = response.request.base_url.to_s
      method = response.request.options[:method]
      response_code = response.code

      debug_msg = "Received a #{response_code} for #{href}"
      debug_msg << " in #{filenames.join(' ')}" unless filenames.nil?
      logger.log :debug, :yellow, debug_msg

      if response_code.between?(200, 299)
        check_hash_in_2xx_response(href, effective_url, response, filenames)
        @cache.add(href, filenames, response_code)
      elsif response.timed_out?
        handle_timeout(href, filenames, response_code)
      elsif response_code == 0
        handle_failure(href, filenames, response_code)
      elsif method == :head
        queue_request(:get, href, filenames)
      else
        return if @options[:only_4xx] && !response_code.between?(400, 499)
        # Received a non-successful http response.
        msg = "External link #{href} failed: #{response_code} #{response.return_message}"
        add_external_issue(filenames, msg, response_code)
        @cache.add(href, filenames, response_code, msg)
      end
    end

    # Even though the response was a success, we may have been asked to check
    # if the hash on the URL exists on the page
    def check_hash_in_2xx_response(href, effective_url, response, filenames)
      return if @options[:only_4xx]
      return unless @options[:check_external_hash]
      return unless (hash = hash?(href))

      body_doc = create_nokogiri(response.body)

      # user-content is a special addition by GitHub.
      xpath = %(//*[@name="#{hash}"]|//*[@id="#{hash}"])
      if URI.parse(href).host.match(/github\.com/i)
        xpath << %(|//*[@name="user-content-#{hash}"]|//*[@id="user-content-#{hash}"])
      end

      return unless body_doc.xpath(xpath).empty?

      msg = "External link #{href} failed: #{effective_url} exists, but the hash '#{hash}' does not"
      add_external_issue(filenames, msg, response.code)
      @cache.add(href, filenames, response.code, msg)
    end

    def handle_timeout(href, filenames, response_code)
      msg = "External link #{href} failed: got a time out (response code #{response_code})"
      @cache.add(href, filenames, 0, msg)
      return if @options[:only_4xx]
      add_external_issue(filenames, msg, response_code)
    end

    def handle_failure(href, filenames, response_code)
      msg = "External link #{href} failed: response code #{response_code} means something's wrong"
      @cache.add(href, filenames, 0, msg)
      return if @options[:only_4xx]
      add_external_issue(filenames, msg, response_code)
    end

    def add_external_issue(filenames, desc, status = nil)
      if filenames.nil?
        @failed_tests << CheckRunner::Issue.new('', desc, nil, status)
      else
        filenames.each { |f| @failed_tests << CheckRunner::Issue.new(f, desc, nil, status) }
      end
    end

    def hash?(url)
      URI.parse(url).fragment
    rescue URI::InvalidURIError
      nil
    end
  end
end
