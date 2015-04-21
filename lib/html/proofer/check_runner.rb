# encoding: utf-8

module HTML
  class Proofer
    # Mostly handles issue management and collecting of external URLs.
    class CheckRunner

      attr_reader :issues, :src, :path, :options, :typhoeus_opts, :hydra_opts, :parallel_opts, \
                  :external_urls, :href_ignores, :alt_ignores, :alt_empty_ignore

      def initialize(src, path, html, options, typhoeus_opts, hydra_opts, parallel_opts)
        @src    = src
        @path   = path
        @html   = remove_ignored(html)
        @options = options
        @typhoeus_opts = typhoeus_opts
        @hydra_opts = hydra_opts
        @parallel_opts = parallel_opts
        @issues = []
        @href_ignores = @options[:href_ignore]
        @alt_ignores = @options[:alt_ignore]
        @alt_empty_ignore = @options[:alt_empty_ignore]
        @external_urls = {}
      end

      def run
        fail NotImplementedError, 'HTML::Proofer::CheckRunner subclasses must implement #run'
      end

      def add_issue(desc, line_number = nil, status = -1)
        @issues << Issue.new(@path, desc, line_number, status)
      end

      def add_to_external_urls(href)
        if @external_urls[href]
          @external_urls[href] << @path
        else
          @external_urls[href] = [@path]
        end
      end

      def self.checks
        classes = []

        ObjectSpace.each_object(Class) do |c|
          next unless c.superclass == self
          classes << c
        end

        classes
      end

    private

      def remove_ignored(html)
        html.css('code, pre').each(&:unlink)
        html
      end
    end
  end
end
