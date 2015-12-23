class HTMLProofer
  # Mostly handles issue management and collecting of external URLs.
  class Check
    attr_reader :issues, :src, :path, :external_urls

    def initialize(src, path, html)
      @src    = src
      @path   = path
      @html   = remove_ignored(html)
      @issues = []
      @external_urls = {}
    end

    def run
      fail NotImplementedError, 'HTMLProofer::Check subclasses must implement #run'
    end

    def add_issue(desc, line_number = nil, status = -1)
      @issues << Issue.new(@path, desc, line_number, status)
    end

    def add_to_external_urls(url, line)
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

    private

    def remove_ignored(html)
      html.css('code, pre, tt').each(&:unlink)
      html
    end
  end
end
