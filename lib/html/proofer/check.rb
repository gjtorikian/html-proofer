# encoding: utf-8
require 'net/http'
require 'net/https'
require 'timeout'
require 'uri'
require 'colored'
require 'typhoeus'

class HTML::Proofer::Checks

  class Check

    attr_reader :issues, :hydra

    def initialize(path, html, opts={})
      @path   = path
      @html   = html
      @options = opts
      @issues = []

      @hydra = Typhoeus::Hydra.hydra
      @additional_href_ignores = @options[:href_ignore] || []
    end

    def run
      raise NotImplementedError.new("HTML::Proofer::Check subclasses must implement #run")
    end

    def add_issue(desc)
      @issues << desc
    end

    def output_filenames
      Dir[@site.config[:output_dir] + '/**/*'].select{ |f| File.file?(f) }
    end

    def external_href?(href)
      uri = URI.parse(href)
      %w( http https ).include?(uri.scheme)
    rescue URI::BadURIError
      false
    rescue URI::InvalidURIError
      false
    end

    def ignore_href?(href)
      uri = URI.parse(href)
      %w( mailto ).include?(uri.scheme) || @additional_href_ignores.include?(href)
    rescue URI::BadURIError
      false
    rescue URI::InvalidURIError
      false
    end

    def validate_url(href, issue_text)
      request = Typhoeus::Request.new(href)
      request.on_complete do |response|
        if response.success?
          # no op
        elsif response.timed_out?
          self.add_issue(issue_text + " got a time out")
        elsif response.code == 0
          # Could not get an http response, something's wrong.
          self.add_issue(issue_text + " #{response}")
        else
          # Received a non-successful http response.
          self.add_issue(issue_text + " HTTP request failed: " + response.code.to_s)
        end
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
