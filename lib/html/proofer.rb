require 'nokogiri'
require 'yell'

begin
  require "awesome_print"
rescue LoadError; end

[
  'checkable',
  'checks',
  'issue'
].each { |r| require File.join(File.dirname(__FILE__), "proofer", r) }

module HTML

  def self.colorize(color, string)
    if $stdout.isatty && $stderr.isatty
      Colored.colorize(string, :foreground => color)
    else
      string
    end
  end

  class Proofer
    include Yell::Loggable

    def initialize(src, opts={})
      @src = src

      @proofer_opts = {
        :ext => ".html",
        :favicon => false,
        :href_swap => [],
        :href_ignore => [],
        :alt_ignore => [],
        :disable_external => false,
        :verbose => false,
        :only_4xx => false,
        :directory_index_file => "index.html"
      }

      @typhoeus_opts = {
        :followlocation => true
      }

      # Typhoeus won't let you pass in any non-Typhoeus option; if the option is not
      # a proofer_opt, it must be for Typhoeus
      opts.keys.each do |key|
        if @proofer_opts[key].nil?
          @typhoeus_opts[key] = opts[key]
        end
      end

      @options = @proofer_opts.merge(@typhoeus_opts).merge(opts)

      @failed_tests = []

      Yell.new({ :format => false, :name => "HTML::Proofer", :level => "gte.#{log_level}" }) do |l|
        l.adapter :stdout, level: [:debug, :info, :warn]
        l.adapter :stderr, level: [:error, :fatal]
      end
    end

    def run
      unless @src.is_a? Array
        total_files = 0
        external_urls = {}

        logger.info HTML::colorize :white, "Running #{get_checks} checks on #{@src} on *#{@options[:ext]}... \n\n"

        files.each do |path|
          total_files += 1
          html = HTML::Proofer.create_nokogiri(path)

          get_checks.each do |klass|
            logger.debug HTML::colorize :blue, "Checking #{klass.to_s.downcase} on #{path} ..."
            check =  Object.const_get(klass).new(@src, path, html, @options)
            check.run
            external_urls.merge!(check.external_urls)
            @failed_tests.concat(check.issues) if check.issues.length > 0
          end
        end

        external_link_checker(external_urls) unless @options[:disable_external]

        logger.info HTML::colorize :green, "Ran on #{total_files} files!\n\n"
      else
        external_urls = Hash[*@src.map{ |s| [s, nil] }.flatten]
        external_link_checker(external_urls) unless @options[:disable_external]
      end

      if @failed_tests.empty?
        logger.info HTML::colorize :green, "HTML-Proofer finished successfully."
      else
        @failed_tests.sort_by(&:path).each do |issue|
          logger.error HTML::colorize :red, issue.to_s
        end

        raise HTML::colorize :red, "HTML-Proofer found #{@failed_tests.length} failures!"
      end
    end

    # the hypothesis is that Proofer runs way faster if we pull out
    # all the external URLs and run the checks at the end. Otherwise, we're halting
    # the consuming process for every file. In addition, sorting the list lets
    # libcurl keep connections to hosts alive. Finally, we'll make a HEAD request,
    # rather than GETing all the contents
    def external_link_checker(external_urls)
      external_urls = Hash[external_urls.sort]

      logger.info HTML::colorize :yellow, "Checking #{external_urls.length} external links..."

      Ethon.logger = logger # log from Typhoeus/Ethon

      external_urls.each_pair do |href, filenames|
        if has_hash? href
          queue_request(:get, href, filenames)
        else
          queue_request(:head, href, filenames)
        end
      end
      logger.debug HTML::colorize :yellow, "Running requests for all #{hydra.queued_requests.size} external URLs..."
      hydra.run
    end

    def queue_request(method, href, filenames)
      request = Typhoeus::Request.new(href, @typhoeus_opts.merge({:method => method}))
      request.on_complete { |response| response_handler(response, filenames) }
      hydra.queue request
    end

    def response_handler(response, filenames)
      effective_url = response.options[:effective_url]
      href = response.request.base_url
      method = response.request.options[:method]
      response_code = response.code

      debug_msg = "Received a #{response_code} for #{href}"
      debug_msg << " in #{filenames.join(' ')}" unless filenames.nil?
      logger.debug debug_msg

      if response_code.between?(200, 299)
        if hash = has_hash?(href)
          hash = hash[1]
          body_doc = Nokogiri::HTML(response.body)
          if body_doc.xpath(%$//*[@name="#{hash}"]|//*[@id="#{hash}"]$).empty?
            add_failed_tests filenames, "External link #{href} failed: #{effective_url} exists, but the hash '#{hash}' does not", response_code
          end
        end
      elsif response.timed_out?
        return if @options[:only_4xx]
        add_failed_tests filenames, "External link #{href} failed: got a time out", response_code
      elsif (response_code == 405 || response_code == 420 || response_code == 503) && method == :head
        # 420s usually come from rate limiting; let's ignore the query and try just the path with a GET
        uri = URI(href)
        queue_request(:get, uri.scheme + "://" + uri.host + uri.path, filenames)
      # just be lazy; perform an explicit get request. some servers are apparently not configured to
      # intercept HTTP HEAD
      elsif method == :head
        queue_request(:get, href, filenames)
      else
        return if @options[:only_4xx] && !response_code.between?(400, 499)
        # Received a non-successful http response.
        add_failed_tests filenames, "External link #{href} failed: #{response_code} #{response.return_message}", response_code
      end
    end

    def hydra
      @hydra ||= Typhoeus::Hydra.new
    end

    def files
      if File.directory? @src
        Dir.glob File.join(@src, "**", "*#{@options[:ext]}")
      elsif File.extname(@src) == @options[:ext]
        [@src]
      else
        []
      end
    end

    def self.create_nokogiri(path)
      content = File.open(path).read
      Nokogiri::HTML(content)
    end

    def get_checks
      checks = HTML::Proofer::Checks::Check.subclasses.map { |c| c.name }
      checks.delete("Favicons") unless @options[:favicon]
      checks
    end

    def has_hash?(url)
      url.match /\#(.+)\/?/
    end

    def log_level
      @options[:verbose] ? :debug : :info
    end

    def add_failed_tests(filenames, desc, status = nil)
      if filenames.nil?
        @failed_tests << Checks::Issue.new("", desc, status)
      elsif
        filenames.each { |f|
          @failed_tests << Checks::Issue.new(f, desc, status)
        }
      end
    end

    def failed_tests
      return [] if @failed_tests.empty?
      result = []
      @failed_tests.each { |f| result << f.to_s }
      result
    end
  end
end
