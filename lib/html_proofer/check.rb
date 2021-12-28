# frozen_string_literal: true

module HTMLProofer
  # Mostly handles issue management and collecting of external URLs.
  class Check
    # attr_reader :node, :html, :element, :src, :path, :options,
    attr_reader :issues, :options, :internal_urls, :external_urls

    def initialize(runner, html)
      @runner = runner
      @html   = remove_ignored(html)

      @issues = []
      @internal_urls = {}
      @external_urls = {}
    end

    def create_element(node)
      Element.new(@runner, node, base_url: base_url)
    end

    def run
      raise NotImplementedError, 'HTMLProofer::Check subclasses must implement #run'
    end

    def add_issue(desc, line: nil, path: nil, status: -1, content: nil)
      @issues << Issue.new(path || @path, desc, line: line, status: status, content: content)
    end

    # def add_to_internal_urls(url, line)
    #   add_to_url_list(url, line, :internal)
    # end

    def add_to_external_urls(url, line)
      add_to_url_list(url, line, :external)
    end

    def self.subchecks(runner_options)
      checks = ObjectSpace.each_object(Class).select do |klass|
        klass < self
      end

      checks.each_with_object([]) do |check, arr|
        check_name = check.to_s
        next if runner_options[:checks_to_ignore].include?(check_name)
        next if check_name == 'HTMLProofer::Check::Favicon' && !runner_options[:check_favicon]
        next if check_name == 'HTMLProofer::Check::OpenGraph' && !runner_options[:check_opengraph]

        arr << check
      end
    end

    private def add_to_url_list(url, line, type)
      url_string = url.to_s
      ivar = instance_variable_get("@#{type}_urls")

      if ivar[url_string]
        ivar[url_string] << {
          current_source: @runner.current_source,
          line: line,
          base_url: base_url
        }
      else
        ivar[url_string] = [{
          current_source: @runner.current_source,
          line: line,
          base_url: base_url
        }]
      end
    end

    private def base_url
      return @base_url if defined?(@base_url)

      return (@base_url = '') if (base = @html.at_css('base')).nil?

      @base_url = base['href']
    end

    private def remove_ignored(html)
      html.css('code, pre, tt').each(&:unlink)
      html
    end
  end
end
