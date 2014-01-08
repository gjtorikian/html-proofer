require 'nokogiri'

require File.dirname(__FILE__) + '/proofer/checkable'
require File.dirname(__FILE__) + '/proofer/checks'

module HTML
  class Proofer
    def initialize(src, opts={})
      @srcDir = src

      @proofer_opts = {:ext => ".html", :href_swap => [], :href_ignore => [], :disable_external => false }
      @options = @proofer_opts.merge({:followlocation => true}).merge(opts)

      @failed_tests = []
    end

    def run
      total_files = 0
      external_urls = {}

      puts "Running #{get_checks} checks on #{@srcDir} on *#{@options[:ext]}... \n\n"

      files.each do |path|
        total_files += 1
        html = HTML::Proofer.create_nokogiri(path)

        get_checks.each do |klass|
          check = klass.new(@srcDir, path, html, @options)
          check.run
          external_urls.merge!(check.external_urls)
          @failed_tests.concat(check.issues) if check.issues.length > 0
        end
      end

      # the hypothesis is that Proofer runs way faster if we pull out
      # all the external URLs and run the checks at the end. Otherwise, we're halting
      # the consuming process for every file. In addition, sorting the list lets
      # libcurl keep connections to hosts alive. Finally, we'll make a HEAD request,
      # rather than GETing all the contents
      external_urls = Hash[external_urls.sort]

      unless @options[:disable_external]
        puts "Checking #{external_urls.length} external links... \n\n"

        # Typhoeus won't let you pass any non-Typhoeus option
        @proofer_opts.each_key do |opt|
          @options.delete opt
        end

        external_urls.each_pair do |href, filenames|
          request = Typhoeus::Request.new(href, @options.merge({:method => :head}))
          request.on_complete { |response| response_handler(response, filenames) }
          hydra.queue request
        end
        hydra.run
      end

      puts "Ran on #{total_files} files!"

      if @failed_tests.empty?
        puts "HTML-Proofer finished successfully.".green
      else
        @failed_tests.each do |issue|
          $stderr.puts issue + "\n\n"
        end

        raise "HTML-Proofer found #{@failed_tests.length} failures!"
      end
    end

    def response_handler(response, filenames)
      href = response.options[:effective_url]
      method = response.request.options[:method]
      response_code = response.code

      if response_code.between?(200, 299)
        # continue with no op
      elsif response.timed_out?
         @failed_tests << "#{filenames.join(' ').blue}: External link #{href} failed: got a time out"
      elsif (response_code == 405 || response_code == 420 || response_code == 503) && method == :head
        # 420s usually come from rate limiting; let's ignore the query and try just the path with a GET
        uri = URI(href)
        next_response = Typhoeus.get(uri.scheme + "://" + uri.host + uri.path, @options)
        response_handler(next_response, filenames)
      # just be lazy; perform an explicit get request. some servers are apparently not configured to
      # intercept HTTP HEAD
      elsif method == :head
        next_response = Typhoeus.get(href, @options)
        response_handler(next_response, filenames)
      else
        # Received a non-successful http response.
        @failed_tests << "#{filenames.join(' ').blue}: External link #{href} failed: #{response_code} #{response.return_message}"
      end
    end

    def hydra
      @hydra ||= Typhoeus::Hydra.new
    end

    def files
      if File.directory? @srcDir
        Dir.glob("#{@srcDir}/**/*#{@options[:ext]}")
      else
        File.extname(@srcDir) == @options[:ext] ? [@srcDir] : []
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
  end
end
