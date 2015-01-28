def require_all(path)
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  Dir[glob].each do |f|
    require f
  end
end

require_all 'proofer'
require_all 'proofer/runner'
require_all 'proofer/checks'

require 'parallel'

begin
  require 'awesome_print'
rescue LoadError; end

module HTML

  class Proofer
    include Utils

    attr_reader :options, :typhoeus_opts, :parallel_opts

    def initialize(src, opts = {})
      @src = src

      @proofer_opts = {
        :ext => '.html',
        :validate_favicon => false,
        :href_swap => [],
        :href_ignore => [],
        :file_ignore => [],
        :check_external_hash => false,
        :alt_ignore => [],
        :disable_external => false,
        :verbose => false,
        :only_4xx => false,
        :directory_index_file => 'index.html',
        :validate_html => false,
        :error_sort => :path
      }

      @typhoeus_opts = opts[:typhoeus] || {
        :followlocation => true
      }
      opts.delete(:typhoeus)

      @hydra_opts = opts[:hydra] || {}
      opts.delete(:hydra)

      # fall back to parallel defaults
      @parallel_opts = opts[:parallel] || {}
      opts.delete(:parallel)

      @options = @proofer_opts.merge(opts)

      @failed_tests = []
    end

    def logger
      @logger ||= HTML::Proofer::Log.new(@options[:verbose])
    end

    def run
      logger.log :info, :blue, "Running #{checks} checks on #{@src} on *#{@options[:ext]}... \n\n"

      if @src.is_a?(Array) && !@options[:disable_external]
        check_list_of_links
      else
        check_directory_of_files
      end

      if @failed_tests.empty?
        logger.log :info, :green, 'HTML-Proofer finished successfully.'
      else
        print_failed_tests
      end
    end

    def check_list_of_links
      external_urls = Hash[*@src.map { |s| [s, nil] }.flatten]
      validate_urls(external_urls)
    end

    # Collects any external URLs found in a directory of files. Also collectes
    # every failed test from check_files_for_internal_woes.
    # Sends the external URLs to Typhoeus for batch processing.
    def check_directory_of_files
      external_urls = {}
      results = check_files_for_internal_woes

      results.each do |item|
        external_urls.merge!(item[:external_urls])
        @failed_tests.concat(item[:failed_tests])
      end

      validate_urls(external_urls) unless @options[:disable_external]

      logger.log :info, :blue, "Ran on #{files.length} files!\n\n"
    end

    # Walks over each implemented check and runs them on the files, in parallel.
    def check_files_for_internal_woes
      Parallel.map(files, @parallel_opts) do |path|
        html = create_nokogiri(path)
        result = { :external_urls => {}, :failed_tests => [] }

        checks.each do |klass|
          logger.log :debug, :yellow, "Checking #{klass.to_s.downcase} on #{path} ..."
          check = Object.const_get(klass).new(@src, path, html, @options)
          check.run
          result[:external_urls].merge!(check.external_urls)
          result[:failed_tests].concat(check.issues) if check.issues.length > 0
        end
        result
      end
    end

    def validate_urls(external_urls)
      url_validator = HTML::Proofer::UrlValidator.new(logger, external_urls, @options, @typhoeus_opts, @hydra_opts)
      @failed_tests.concat(url_validator.run)
    end

    def files
      if File.directory? @src
        pattern = File.join(@src, '**', "*#{@options[:ext]}")
        files = Dir.glob(pattern).select { |fn| File.file? fn }
        files.reject { |f| ignore_file?(f) }
      elsif File.extname(@src) == @options[:ext]
        [@src].reject { |f| ignore_file?(f) }
      else
        []
      end
    end

    def ignore_file?(file)
      @options[:file_ignore].each do |pattern|
        if pattern.is_a? String
          return pattern == file
        elsif pattern.is_a? Regexp
          return pattern =~ file
        end
      end

      false
    end

    def checks
      checks = HTML::Proofer::Runner.checks.map(&:name)
      checks.delete('FaviconRunner') unless @options[:validate_favicon]
      checks.delete('HtmlRunner') unless @options[:validate_html]
      checks
    end

    def failed_tests
      return [] if @failed_tests.empty?
      result = []
      @failed_tests.each { |f| result << f.to_s }
      result
    end

    def print_failed_tests
      sorted_failures = HTML::Proofer::Runner::SortedIssues.new(@failed_tests, @options[:error_sort], logger)

      sorted_failures.sort_and_report
      count = @failed_tests.length
      failure_text = "#{count} " << (count == 1 ? 'failure' : 'failures')
      fail logger.colorize :red, "HTML-Proofer found #{@failed_tests.length} #{failure_text}!"
    end
  end
end
