require 'nokogiri'

require File.dirname(__FILE__) + '/proofer/checkable'
require File.dirname(__FILE__) + '/proofer/checks'

module HTML
  class Proofer
    def initialize(src, opts={})
      @srcDir = src
      # Typhoeus::Config.verbose = true
      @proofer_opts = {:ext => ".html", :href_swap => [], :href_ignore => [], :disable_external => false }
      @options = @proofer_opts.merge({:followlocation => true, :ssl_verifypeer => false}).merge(opts)
    end

    def run
      total_files = 0
      external_urls = {}
      failed_tests = []
      hydra = Typhoeus::Hydra.new(max_concurrency: 100)

      puts "Running #{get_checks} checks on #{@srcDir} on *#{@options[:ext]}... \n\n"

      if File.directory? @srcDir
        files = Dir.glob("#{@srcDir}/**/*#{@options[:ext]}")
      else
        files = File.extname(@srcDir) == @options[:ext] ? [@srcDir] : []
      end

      files.each do |path|
        total_files += 1
        html = HTML::Proofer.create_nokogiri(path)

        get_checks.each do |klass|
          check = klass.new(@srcDir, path, html, @options)
          check.run
          external_urls.merge!(check.external_urls)
          failed_tests.concat(check.issues) if check.issues.length > 0
        end
      end

      # the hypothesis is that Proofer runs way faster if we pull out
      # all the external URLs and run the checks at the end. Otherwise, we're halting
      # the consuming process for every file. In addition, sorting the list lets
      # libcurl keep connections to hosts alive
      external_urls = Hash[external_urls.sort]

      unless @options[:disable_external]
        puts "Checking #{external_urls.length} external links... \n\n"

        # Typhoeus won't let me pass any non-Typhoeus option
        @proofer_opts.each_key do |opt|
          @options.delete opt
        end

        Typhoeus.on_failure do |response|
          href = response.options[:effective_url].sub(/\/$/, '')
          filenames = external_urls[href] || []
          failed_tests << "#{filenames.join(' ').blue}: External link #{href} failed: could not resolve host"
        end

        external_urls.each_pair do |href, filenames|
          request = Typhoeus::Request.new(href, @options)
          request.on_headers do |response|
            href = response.options[:effective_url]
            response_code = response.code

            if response_code.between?(200, 299)
              next # continue with no op
            elsif response.timed_out?
               failed_tests << "#{filenames.join(' ').blue}: External link #{href} failed: got a time out"
            else
              if response_code == 420 || response_code == 503
                # 420s usually come from rate limiting; let's ignore the query and try just the path
                uri = URI(href)
                second_response = Typhoeus.get(uri.scheme + "://" + uri.host + uri.path, @options)
                failed_tests << "#{filenames.join(' ').blue}: External link #{href} failed: originally, this was a #{response_code.to_s}. Now, the HTTP request failed again: #{second_response.code.to_s}" unless second_response.success?
              else
                # Received a non-successful http response.
                failed_tests << "#{filenames.join(' ').blue}: External link #{href} failed: #{response_code} #{response.return_message}"
              end
            end
          end
          hydra.queue request
        end
        hydra.run
      end

      puts "Ran on #{total_files} files!"

      if failed_tests.empty?
        puts "HTML-Proofer finished successfully.".green
      else
        failed_tests.each do |issue|
          $stderr.puts issue + "\n\n"
        end

        raise "HTML-Proofer found #{failed_tests.length} failures!"
      end
    end

    def self.create_nokogiri(path)
      path << "/index.html" if File.directory? path # support for Jekyll-style links
      content = File.open(path, "rb") {|f| f.read }
      Nokogiri::HTML(content)
    end

    def get_checks
      HTML::Proofer::Checks::Check.subclasses
    end


    private

    # Check a URL.
    #
    # @param uri [URI] A URI object for the target URL.
    # @return [LinkChecker::Result] One of the following objects: {LinkChecker::Good},
    #   {LinkChecker::Redirect}, or {LinkChecker::Error}.
    def self.check_uri(uri, redirected=false)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == "https"
      http.start do
        path = (uri.path.empty?) ? '/' : uri.path
        http.request_get(path) do |response|
          case response
          when Net::HTTPSuccess then
            if redirected
              return Redirect.new(:final_destination_uri_string => uri.to_s)
            else
              return Good.new(:uri_string => uri.to_s)
            end
          when Net::HTTPRedirection then
            uri =
              if response['location'].match(/\:\/\//) # Allows for https://
                URI(response['location'])
              else
                # If the redirect is relative we need to build a new uri
                # using the current uri as a base.
                URI.join("#{uri.scheme}://#{uri.host}:#{uri.port}", response['location'])
              end
            return self.check_uri(uri, true)
          else
            return Error.new(:uri_string => uri.to_s, :error => response)
          end
        end
      end
    end

    # Checks the current :max_threads setting and blocks until the number of threads is
    # below that number.
    def wait_to_spawn_thread
      # Never spawn more than the specified maximum number of threads.
      until Thread.list.select {|thread| thread.status == "run"}.count <
        (1 + @options[:max_threads]) do
        # Wait 5 milliseconds before trying again.
        sleep 0.005
      end
    end
  end
end
