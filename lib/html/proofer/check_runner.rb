# encoding: utf-8

module HTML
  class Proofer
    # Mostly handles issue management and collecting of external URLs.
    class CheckRunner

      attr_reader :issues, :src, :path, :options, :typhoeus_opts, :hydra_opts, :parallel_opts, \
                  :validation_opts, :external_urls, :href_ignores, :url_ignores, :alt_ignores, :empty_alt_ignore

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
        @external_domain_paths_with_queries = {}
      end

      def run
        fail NotImplementedError, 'HTML::Proofer::CheckRunner subclasses must implement #run'
      end

      def add_issue(desc, line_number = nil, status = -1)
        @issues << Issue.new(@path, desc, line_number, status)
      end

      def add_to_external_urls(url)
        return if @external_urls[url]
        uri = Addressable::URI.parse(url)

        if uri.query.nil?
          add_path_for_url(url)
        else
          new_url_query_values?(uri, url)
        end
      end

      def add_path_for_url(url)
        if @external_urls[url]
          @external_urls[url] << @path
        else
          @external_urls[url] = [@path]
        end
      end

      def new_url_query_values?(uri, url)
        queries = uri.query_values.keys.join('-')
        domain_path = extract_domain_path(uri)
        if @external_domain_paths_with_queries[domain_path].nil?
          add_path_for_url(url)
          # remember queries we've seen, ignore future ones
          @external_domain_paths_with_queries[domain_path] = [queries]
        else
          # add queries we haven't seen
          unless @external_domain_paths_with_queries[domain_path].include?(queries)
            add_path_for_url(url)
            @external_domain_paths_with_queries[domain_path] << queries
          end
        end
      end

      def extract_domain_path(uri)
        uri.host + uri.path
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
