# encoding: utf-8

module HTML
  class Proofer
    # Mostly handles issue management and collecting of external URLs.
    class CheckRunner

      attr_reader :issues, :src, :path, :options, :typhoeus_opts, :hydra_opts, :parallel_opts, \
                  :validation_opts, :external_urls, :href_ignores, :url_ignores, :alt_ignores, \
                  :empty_alt_ignore

      def initialize(src, path, html, options, typhoeus_opts, hydra_opts, parallel_opts, validation_opts)
        @src    = src
        @path   = path
        @html   = remove_ignored(html)
        @options = options
        @typhoeus_opts = typhoeus_opts
        @hydra_opts = hydra_opts
        @parallel_opts = parallel_opts
        @validation_opts = validation_opts
        @issues = []
        @href_ignores = @options[:href_ignore]
        @url_ignores = @options[:url_ignore]
        @alt_ignores = @options[:alt_ignore]
        @empty_alt_ignore = @options[:empty_alt_ignore]
        @external_urls = {}
      end

      def run
        fail NotImplementedError, 'HTML::Proofer::CheckRunner subclasses must implement #run'
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
        html.css('code, pre, tt').each(&:unlink)
        html
      end
    end
  end
end
