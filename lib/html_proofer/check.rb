# frozen_string_literal: true

module HTMLProofer
  # Mostly handles issue management and collecting of external URLs.
  class Check
    include HTMLProofer::Utils

    attr_reader :failures, :options, :internal_urls, :external_urls

    def initialize(runner, html)
      @runner = runner
      @html   = remove_ignored(html)

      @failures = []
      @internal_urls = {}
      @external_urls = {}
    end

    def create_element(node)
      Element.new(@runner, node, base_url: base_url)
    end

    def run
      raise NotImplementedError, 'HTMLProofer::Check subclasses must implement #run'
    end

    def add_failure(desc, line: nil, path: nil, status: -1, content: nil)
      @failures << Failure.new(path || @path, desc, line: line, status: status, content: content)
    end

    def self.subchecks(runner_options)
      # grab all known checks
      checks = ObjectSpace.each_object(Class).select do |klass|
        klass < self
      end

      # remove any checks not explicitly included
      checks.each_with_object([]) do |check, arr|
        check_name = check.to_s.split('::').last
        next unless runner_options[:checks].include?(check_name)

        arr << check
      end
    end

    def add_to_internal_urls(url, line)
      url_string = url.to_s

      @internal_urls[url_string] = [] if @internal_urls[url_string].nil?

      metadata = @runner.cache.construct_internal_link_metadata({
                                                                  source: @runner.current_source,
                                                                  current_path: @runner.current_path,
                                                                  line: line,
                                                                  base_url: base_url
                                                                })
      @internal_urls[url_string] << metadata
    end

    def add_to_external_urls(url, line)
      url_string = url.to_s

      @external_urls[url_string] = [] if @external_urls[url_string].nil?

      @external_urls[url_string] << { filename: @runner.current_source, line: line }
    end

    private def html5?
      @html.to_s.scan(/^<!DOCTYPE html>/).any?
    end

    private def base_url
      return @base_url if defined?(@base_url)

      return (@base_url = '') if (base = @html.at_css('base')).nil?

      @base_url = base['href']
    end

    private def remove_ignored(html)
      return if html.nil?

      html.css('code, pre, tt').each(&:unlink)
      html
    end
  end
end
