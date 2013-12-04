# encoding: utf-8
require 'net/http'
require 'net/https'
require 'timeout'
require 'uri'
require 'colored'
require 'typhoeus'

class HTML::Proofer::Checks

  class Check

    attr_reader :issues, :hydra, :src, :path, :options, :additional_href_ignores

    def initialize(src, path, html, opts={})
      @src    = src
      @path   = path
      @html   = html
      @options = opts
      @issues = []
      @checked_urls = {}

      @hydra = Typhoeus::Hydra.hydra
      @additional_href_ignores = @options[:href_ignore] || []
    end

    def run
      raise NotImplementedError.new("HTML::Proofer::Check subclasses must implement #run")
    end

    def add_issue(desc)
      @issues << "#{@path.blue}: #{desc}"
    end

    def output_filenames
      Dir[@site.config[:output_dir] + '/**/*'].select{ |f| File.file?(f) }
    end

    def validate_url(href, issue_text)
      return @checked_urls[href] if @checked_urls.has_key? href
      request = Typhoeus::Request.new(href, {:followlocation => true})
      request.on_complete do |response|
        if response.success?
          @checked_urls[href] = true
        elsif response.timed_out?
          self.add_issue(issue_text + " got a time out")
        elsif response.code == 0
          # Could not get an http response, something's wrong.
          self.add_issue(issue_text + ". #{response.return_message}!")
        else
          response_code = response.code.to_s
          if %w(420 503).include?(response_code)
            # 420s usually come from rate limiting; let's ignore the query and try just the path
            uri = URI(href)
            response = Typhoeus.get(uri.scheme + "://" + uri.host + uri.path, {:followlocation => true})
            self.add_issue("#{issue_text} Originally, this was a #{response_code}. Now, the HTTP request failed again: #{response.code.to_s}") unless response.success?
          else
            # Received a non-successful http response.
            self.add_issue("#{issue_text} HTTP request failed: #{response_code}")
          end
        end

        @checked_urls[href] = false unless response.success?
      end
      hydra.queue(request)
    end

    def request_url(url)
      path = (url.path.nil? || url.path.empty? ? '/' : url.path)
      req = Net::HTTP::Head.new(path)
      http = Net::HTTP.new(url.host, url.port)
      if url.instance_of? URI::HTTPS
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      res = http.request(req)
    end

    def self.subclasses
      classes = []

      ObjectSpace.each_object(Class) do |c|
        next unless c.superclass == self
        classes << c
      end

      classes
    end

  end
end
