# encoding: utf-8
require 'net/http'
require 'net/https'
require 'timeout'
require 'uri'
require 'colored'
require 'typhoeus'

class HTML::Proofer::Checks

  class Check

    attr_reader :issues, :src, :path, :options, :external_urls, :additional_href_ignores, :additional_alt_ignores

    def initialize(src, path, html, opts={})
      @src    = src
      @path   = path
      @html   = html
      @options = opts
      @issues = []
      @additional_href_ignores = @options[:href_ignore]
      @additional_alt_ignores = @options[:alt_ignore]
      @external_urls = {}
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

    def add_to_external_urls(href)
      if @external_urls[href]
        @external_urls[href] << @path
      else
        @external_urls[href] = [@path]
      end
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
