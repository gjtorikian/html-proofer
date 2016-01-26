def require_all(path)
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  Dir[glob].each do |f|
    require f
  end
end

require_all 'proofer'
require_all 'proofer/check_runner'
require_all 'proofer/checks'

require 'parallel'
require 'fileutils'

begin
  require 'awesome_print'
rescue LoadError; end

module HTML
  class Proofer
    include HTML::Proofer::Utils

    attr_reader :options, :typhoeus_opts, :hydra_opts, :parallel_opts, :validation_opts, :external_urls, :iterable_external_urls

    def initialize(src, opts = {})
      FileUtils.mkdir_p(STORAGE_DIR) unless File.exist?(STORAGE_DIR)

      @src = src

      if opts[:verbose]
        warn '`@options[:verbose]` will be removed in a future 3.x.x release: http://git.io/vGHHh'
      end
      if opts[:href_ignore]
        warn '`@options[:href_ignore]` will be renamed in a future 3.x.x release: http://git.io/vGHHy'
      end

      @proofer_opts = HTML::Proofer::Configuration::PROOFER_DEFAULTS

      @typhoeus_opts = HTML::Proofer::Configuration::TYPHOEUS_DEFAULTS.merge(opts[:typhoeus] || {})
      opts.delete(:typhoeus)

      @hydra_opts = HTML::Proofer::Configuration::HYDRA_DEFAULTS.merge(opts[:hydra] || {})
      opts.delete(:hydra)

      # fall back to parallel defaults
      @parallel_opts = opts[:parallel] || {}
      opts.delete(:parallel)

      @validation_opts = opts[:validation] || {}
      opts.delete(:validation)

      @options = @proofer_opts.merge(opts)

      @failed_tests = []
    end

    def logger
      @logger ||= HTML::Proofer::Log.new(@options[:verbose], @options[:verbosity])
    end

    def run
      logger.log :info, :blue, "Running #{checks} on #{@src} on *#{@options[:ext]}... \n\n"

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
      if @options[:href_swap]
        @src = @src.map do |url|
          swap(url, @options[:href_swap])
        end
      end
      @external_urls = Hash[*@src.map { |s| [s, nil] }.flatten]
      validate_urls
    end

    # Collects any external URLs found in a directory of files. Also collectes
    # every failed test from check_files_for_internal_woes.
    # Sends the external URLs to Typhoeus for batch processing.
    def check_directory_of_files
      @external_urls = {}
      results = check_files_for_internal_woes

      results.each do |item|
        @external_urls.merge!(item[:external_urls])
        @failed_tests.concat(item[:failed_tests])
      end

      # TODO: lazy. if we're checking only external links,
      # we'll just trash all the failed tests. really, we should
      # just not run those other checks at all.
      if @options[:external_only]
        @failed_tests = []
        validate_urls
      elsif !@options[:disable_external]
        validate_urls
      end

      count = files.length
      file_text = pluralize(count, 'file', 'files')
      logger.log :info, :blue, "Ran on #{file_text}!\n\n"
    end

    # Walks over each implemented check and runs them on the files, in parallel.
    def check_files_for_internal_woes
      if @parallel_opts.empty?
        files.map { |path| check_path(path) }
      else
        Parallel.map(files, @parallel_opts) { |path| check_path(path) }
      end
    end

    def check_path(path)
      html = create_nokogiri(path)
      result = { :external_urls => {}, :failed_tests => [] }

      checks.each do |klass|
        logger.log :debug, :yellow, "Checking #{klass.to_s.downcase} on #{path} ..."
        check = Object.const_get(klass).new(@src, path, html, @options, @typhoeus_opts, @hydra_opts, @parallel_opts, @validation_opts)
        check.run
        result[:external_urls].merge!(check.external_urls)
        result[:failed_tests].concat(check.issues) if check.issues.length > 0
      end
      result
    end

    def validate_urls
      url_validator = HTML::Proofer::UrlValidator.new(logger, @external_urls, @options, @typhoeus_opts, @hydra_opts)
      @failed_tests.concat(url_validator.run)
      @iterable_external_urls = url_validator.iterable_external_urls
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
      options[:file_ignore].each do |pattern|
        return true if pattern.is_a?(String) && pattern == file
        return true if pattern.is_a?(Regexp) && pattern =~ file
      end

      false
    end

    def checks
      return @checks unless @checks.nil?
      @checks = HTML::Proofer::CheckRunner.checks.map(&:name)
      @checks.delete('FaviconCheck') unless @options[:check_favicon]
      @checks.delete('HtmlCheck') unless @options[:check_html]
      @options[:checks_to_ignore].each do |ignored|
        @checks.delete(ignored)
      end
      @checks
    end

    def failed_tests
      return [] if @failed_tests.empty?
      result = []
      @failed_tests.each { |f| result << f.to_s }
      result
    end

    def print_failed_tests
      sorted_failures = HTML::Proofer::CheckRunner::SortedIssues.new(@failed_tests, @options[:error_sort], logger)

      sorted_failures.sort_and_report
      count = @failed_tests.length
      failure_text = pluralize(count, 'failure', 'failures')
      fail logger.colorize :red, "HTML-Proofer found #{failure_text}!"
    end
  end
end
