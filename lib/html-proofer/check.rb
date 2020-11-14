# frozen_string_literal: true

module HTMLProofer
  # Mostly handles issue management and collecting of external URLs.
  class Check
    attr_reader :node, :html, :element, :src, :path, :options, :issues, :internal_urls, :external_urls

    def initialize(src, path, html, logger, cache, options)
      @src    = src
      @path   = path
      @html   = remove_ignored(html)
      @logger = logger
      @cache = cache
      @options = options
      @issues = []
      @internal_urls = {}
      @external_urls = {}
    end

    def create_element(node)
      @node = node
      Element.new(node, self, @logger)
    end

    def run
      raise NotImplementedError, 'HTMLProofer::Check subclasses must implement #run'
    end

    def add_issue(desc, line: nil, status: -1, content: nil)
      @issues << Issue.new(@path, desc, line: line, status: status, content: content)
      false
    end

    def add_to_internal_urls(url)
      add_path_for_url(url, type: :internal)
    end

    def add_to_external_urls(url)
      return if @external_urls[url]

      add_path_for_url(url, type: :external)
    end

    def add_path_for_url(url, type: :external)
      if type == :external
        if @external_urls[url]
          @external_urls[url] << @path
        else
          @external_urls[url] = [@path]
        end
      else
        if @internal_urls[url]
          @internal_urls[url] << @path
        else
          @internal_urls[url] = [@path]
        end
      end
    end

    def self.subchecks
      classes = []

      ObjectSpace.each_object(Class) do |c|
        next unless c.superclass == self

        classes << c
      end

      classes
    end

    def blank?(attr)
      attr.nil? || attr.empty?
    end

    private

    def remove_ignored(html)
      html.css('code, pre, tt').each(&:unlink)
      html
    end
  end
end
