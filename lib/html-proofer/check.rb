module HTMLProofer
  # Mostly handles issue management and collecting of external URLs.
  class Check
    attr_reader :node, :html, :element, :src, :path, :options, :issues, :external_urls

    def initialize(src, path, html, options)
      @src    = src
      @path   = path
      @html   = remove_ignored(html)
      @options = options
      @issues = []
      @external_urls = {}
    end

    def create_element(node)
      @node = node
      Element.new(node, self)
    end

    def run
      raise NotImplementedError, 'HTMLProofer::Check subclasses must implement #run'
    end

    def add_issue(desc, line: nil, status: -1, content: nil)
      @issues << Issue.new(@path, desc, line: line, status: status, content: content)
    end

    def add_to_external_urls(url)
      return if @external_urls[url]
      add_path_for_url(url)
    end

    def add_path_for_url(url)
      if @external_urls[url]
        @external_urls[url] << @path
      else
        @external_urls[url] = [@path]
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
