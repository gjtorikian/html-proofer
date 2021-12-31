# frozen_string_literal: true

module HTMLProofer
  class Runner
    include HTMLProofer::Utils

    attr_reader :options, :cache, :logger, :internal_urls, :external_urls, :failure_reporter, :checked_paths, :current_check
    attr_accessor :current_path, :current_source

    def initialize(src, opts = {})
      @options = HTMLProofer::Configuration.generate_defaults(opts)

      @type = @options.delete(:type)
      @source = src

      @logger = HTMLProofer::Log.new(@options[:log_level])
      @cache = Cache.new(self, @options[:cache])

      @internal_urls = {}
      @external_urls = {}
      @failures = []
      @before_request = []

      @checked_paths = {}

      @current_check = nil
      @current_source = nil
      @current_path = nil
    end

    def run
      check_text = pluralize(checks.length, 'check', 'checks')

      if @type == :links
        @logger.log :info, "Running #{check_text} (#{format_checks_list(checks)}) on #{@source}... \n\n"
        check_list_of_links unless @options[:disable_external]
      else
        @logger.log :info, "Running #{check_text} (#{format_checks_list(checks)}) on #{@source} on *#{@options[:extension]}... \n\n"

        check_files
        @logger.log :info, "Ran on #{pluralize(files.length, 'file', 'files')}!\n\n"
      end

      @cache.write

      @failure_reporter = FailureReporter.new(@failures, @logger)

      if @failures.empty?
        @logger.log :info, 'HTML-Proofer finished successfully.'
      else
        @failures.uniq!
        print_failed_tests
      end
    end

    def check_list_of_links
      @external_urls = @source.uniq.each_with_object({}) do |link, hash|
        url = Attribute::Url.new(self, link, base_url: nil).to_s

        hash[url] = []
      end

      validate_external_urls
    end

    # Collects any external URLs found in a directory of files. Also collectes
    # every failed test from process_files.
    # Sends the external URLs to Typhoeus for batch processing.
    def check_files
      process_files.each do |item|
        @external_urls.merge!(item[:external_urls])
        @internal_urls.merge!(item[:internal_urls])
        @failures.concat(item[:failures])
      end

      validate_external_urls unless @options[:disable_external]

      validate_internal_urls
    end

    # Walks over each implemented check and runs them on the files, in parallel.
    def process_files
      if @options[:parallel][:enable]
        Parallel.map(files, @options[:parallel]) { |path| load_file(path) }
      else
        files.map { |path| load_file(path) }
      end
    end

    def load_file(path)
      @html = create_nokogiri(path)
      check_parsed(path)
    end

    def check_parsed(path)
      result = { internal_urls: {}, external_urls: {}, failures: [] }

      @source = [@source] if @type == :file

      @source.each do |current_source|
        checks.each do |klass|
          @logger.log :debug, "Checking #{klass.to_s.downcase} on #{path} ..."
          @current_source = current_source
          @current_path = path

          check = Object.const_get(klass).new(self, @html)
          @current_check = check

          check.run

          result[:external_urls].merge!(check.external_urls)
          result[:internal_urls].merge!(check.internal_urls)
          result[:failures].concat(check.failures)
        end
      end
      result
    end

    def validate_external_urls
      external_url_validator = HTMLProofer::UrlValidator::External.new(self, @external_urls)
      external_url_validator.before_request = @before_request
      @failures.concat(external_url_validator.validate)
    end

    def validate_internal_urls
      internal_link_validator = HTMLProofer::UrlValidator::Internal.new(self, @internal_urls)
      @failures.concat(internal_link_validator.validate)
    end

    def files
      @files ||= if @type == :directory
                   @source.map do |src|
                     pattern = File.join(src, '**', "*#{@options[:extension]}")
                     files = Dir.glob(pattern).select { |fn| File.file? fn }
                     files.reject { |f| ignore_file?(f) }
                   end.flatten
                 elsif @type == :file && File.extname(@source) == @options[:extension]
                   [@source].reject { |f| ignore_file?(f) }
                 else
                   []
                 end
    end

    def ignore_file?(file)
      @options[:ignore_files].each do |pattern|
        return true if pattern.is_a?(String) && pattern == file
        return true if pattern.is_a?(Regexp) && pattern =~ file
      end

      false
    end

    def check_sri?
      @options[:check_sri]
    end

    def enforce_https?
      @options[:enforce_https]
    end

    def checks
      return @checks if defined?(@checks) && !@checks.nil?

      return (@checks = ['LinkCheck']) if @type == :links

      @checks = HTMLProofer::Check.subchecks(@options).map(&:name)

      @checks
    end

    def failed_tests
      @failure_reporter.failures
    end

    def print_failed_tests
      @failure_reporter.report(:cli)

      failure_text = pluralize(@failures.length, 'failure', 'failures')
      @logger.log :fatal, "\nHTML-Proofer found #{failure_text}!"
      exit 1
    end

    # Set before_request callback.
    #
    # @example Set before_request.
    #   request.before_request { |request| p "yay" }
    #
    # @param [ Block ] block The block to execute.
    #
    # @yield [ Typhoeus::Request ]
    #
    # @return [ Array<Block> ] All before_request blocks.
    def before_request(&block)
      @before_request ||= []
      @before_request << block if block
      @before_request
    end

    def load_internal_cache
      urls_to_check = @cache.retrieve_urls(@internal_urls, :internal)
      cache_text = pluralize(urls_to_check.count, 'internal link', 'internal links')
      @logger.log :info, "Found #{cache_text} in the cache..."

      urls_to_check
    end

    def load_external_cache
      urls_to_check = @cache.retrieve_urls(@external_urls, :external)
      cache_text = pluralize(urls_to_check.count, 'external link', 'external links')
      @logger.log :info, "Found #{cache_text} in the cache..."

      urls_to_check
    end

    private def format_checks_list(checks)
      checks.map do |check|
        check.sub(/HTMLProofer::Check::/, '')
      end.join(', ')
    end
  end
end
