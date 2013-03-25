# encoding: utf-8
require 'net/http'
require 'net/https'
require 'timeout'
require 'uri'
require 'colored'

class HTML::Proofer::Checks

  class Check

    attr_reader :issues

    def initialize(path, html, opts={})
      @path   = path
      @html   = html
      @options = opts
      @issues = []

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

    def validate_url(href)
      # Parse
      url = nil
      begin
        url = URI.parse(href)
      rescue URI::InvalidURIError
        return Result.new(href, 'invalid URI')
      end

      # Get status
      res = nil
      5.times do |i|
        begin
          Timeout::timeout(10) do
            res = request_url(url)
          end
        rescue => e
          return nil
        end

        if res.code =~ /^[3|5]..$/
          if i == 4
            return nil
          end

          # Find proper location
          location = res['Location']
          if location !~ /^https?:\/\//
            base_url = url.dup
            base_url.path = (location =~ /^\// ? '' : '/')
            base_url.query = nil
            base_url.fragment = nil
            location = base_url.to_s + location
          end
          url = URI.parse(location)
        elsif res.code == '200'
          return true
        else
          return nil
        end
      end
      raise 'should not have gotten here'
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
