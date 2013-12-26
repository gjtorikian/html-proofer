require 'nokogiri'
require File.dirname(__FILE__) + '/proofer/checkable'
require File.dirname(__FILE__) + '/proofer/checks'

module HTML
  class Proofer
    def initialize(src, opts={})
      @srcDir = src
      @options = {:ext => ".html", :disable_external => true, :followlocation => true}.merge(opts)
    end

    def run
      total_files = 0
      external_urls = {}
      failed_tests = []
      hydra = Typhoeus::Hydra.hydra

      puts "Running #{get_checks} checks on #{@srcDir} on *#{@options[:ext]}... \n\n"

      Dir.glob("#{@srcDir}/**/*#{@options[:ext]}") do |path|
        total_files += 1
        html = HTML::Proofer.create_nokogiri(path)

        get_checks.each do |klass|
          check = klass.new(@srcDir, path, html, @options)
          check.run
          external_urls.merge!(check.external_urls)
          failed_tests.concat(check.issues) if check.issues.length > 0
        end
      end

      unless @options[:disable_external]
        puts "Checking #{external_urls.length} external links... \n\n"

        # the hypothesis is that Proofer runs way faster if we pull out
        # all the external URLs and run the checks at the end. Otherwise, we're halting
        # the consuming process for every file.
        external_urls.each_pair do |href, filename|
          request = Typhoeus::Request.new(href, @options)
          request.on_complete do |response|
            href = response.options[:effective_url]

            if response.success?
              next # continue with no op
            elsif response.timed_out?
               failed_tests << "#{filename.blue}: External link #{href} failed: got a time out"
            elsif response.code == 0
              # Could not get an http response, something's wrong.
              failed_tests << "#{filename.blue}: External link #{href} failed: #{response.return_message}!"
            else
              response_code = response.code.to_s
              if %w(420 503).include?(response_code)
                # 420s usually come from rate limiting; let's ignore the query and try just the path
                uri = URI(href)
                second_response = Typhoeus.get(uri.scheme + "://" + uri.host + uri.path, {:followlocation => true})
                failed_tests << "#{filename.blue}: External link #{href} failed: originally, this was a #{response_code}. Now, the HTTP request failed again: #{second_response.code.to_s}" unless second_response.success?
              else
                # Received a non-successful http response.
                failed_tests << "#{filename.blue}: External link #{href} failed: #{response_code}"
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
        exit 0
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
  end
end
