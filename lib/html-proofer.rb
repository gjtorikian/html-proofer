def require_all(path)
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  Dir[glob].each do |f|
    require f
  end
end

require_all 'html-proofer'
require_all 'html-proofer/check'

require 'parallel'
require 'fileutils'

begin
  require 'awesome_print'
rescue LoadError; end

class HTMLProofer
  include HTMLProofer::Utils

  attr_reader :options, :external_urls

  def initialize(src, opts = {})
    FileUtils.mkdir_p(STORAGE_DIR) unless File.exist?(STORAGE_DIR)

    @src = src

    if opts[:verbose]
      warn '`@options[:verbose]` will be removed in a future 3.x.x release: http://git.io/vGHHh'
    end

    @options = HTMLProofer::Configuration::PROOFER_DEFAULTS.merge(opts)

    @options[:typhoeus] = HTMLProofer::Configuration::TYPHOEUS_DEFAULTS.merge(opts[:typhoeus] || {})
    @options[:hydra] = HTMLProofer::Configuration::HYDRA_DEFAULTS.merge(opts[:hydra] || {})

    @options[:parallel] = HTMLProofer::Configuration::PARALLEL_DEFAULTS.merge(opts[:parallel] || {})
    @options[:validation] = HTMLProofer::Configuration::VALIDATION_DEFAULTS.merge(opts[:validation] || {})
    @options[:cache] = HTMLProofer::Configuration::CACHE_DEFAULTS.merge(opts[:cache] || {})

    @failed_tests = []
  end

  def logger
    @logger ||= HTMLProofer::Log.new(@options[:verbose], @options[:verbosity])
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
    if @options[:url_swap]
      @src = @src.map do |url|
        swap(url, @options[:url_swap])
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

    check_files_for_internal_woes.each do |item|
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
    Parallel.map(files, @options[:parallel]) do |path|
      result = { :external_urls => {}, :failed_tests => [] }
      html = create_nokogiri(path)

      checks.each do |klass|
        logger.log :debug, :yellow, "Checking #{klass.to_s.downcase} on #{path} ..."
        check = Object.const_get(klass).new(@src, path, html, @options)
        check.run
        result[:external_urls].merge!(check.external_urls)
        result[:failed_tests].concat(check.issues)
      end
      result
    end
  end

  def validate_urls
    url_validator = HTMLProofer::UrlValidator.new(logger, @external_urls, @options)
    @failed_tests.concat(url_validator.run)
    @external_urls = url_validator.external_urls
  end

  def files
    @files ||= if File.directory? @src
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
      return true if pattern.is_a?(String) && pattern == file
      return true if pattern.is_a?(Regexp) && pattern =~ file
    end

    false
  end

  def checks
    return @checks unless @checks.nil?
    @checks = HTMLProofer::Check.subchecks.map(&:name)
    @checks.delete('FaviconCheck') unless @options[:check_favicon]
    @checks.delete('HtmlCheck') unless @options[:check_html]
    @options[:checks_to_ignore].each { |ignored| @checks.delete(ignored) }
    @checks
  end

  def failed_tests
    result = []
    return result if @failed_tests.empty?
    @failed_tests.each { |f| result << f.to_s }
    result
  end

  def print_failed_tests
    sorted_failures = SortedIssues.new(@failed_tests, @options[:error_sort], logger)

    sorted_failures.sort_and_report
    count = @failed_tests.length
    failure_text = pluralize(count, 'failure', 'failures')
    fail logger.colorize :red, "HTML-Proofer found #{failure_text}!"
  end
end
