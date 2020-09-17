# frozen_string_literal: true

module HTMLProofer
  class Runner
    include HTMLProofer::Utils

    attr_reader :options, :external_urls, :failures

    def initialize(src, opts = {})
      @src = src

      @options = HTMLProofer::Configuration::PROOFER_DEFAULTS.merge(opts)

      @options[:typhoeus] = HTMLProofer::Configuration::TYPHOEUS_DEFAULTS.merge(opts[:typhoeus] || {})
      @options[:hydra] = HTMLProofer::Configuration::HYDRA_DEFAULTS.merge(opts[:hydra] || {})

      @options[:parallel] = HTMLProofer::Configuration::PARALLEL_DEFAULTS.merge(opts[:parallel] || {})
      @options[:validation] = HTMLProofer::Configuration::VALIDATION_DEFAULTS.merge(opts[:validation] || {})
      @options[:cache] = HTMLProofer::Configuration::CACHE_DEFAULTS.merge(opts[:cache] || {})

      @type = @options.delete(:type)
      @logger = HTMLProofer::Log.new(@options[:log_level])

      # Add swap patterns for internal domains
      unless @options[:internal_domains].empty?
        @options[:internal_domains].each do |dom|
          @options[:url_swap][Regexp.new("^http://#{dom}")] = ''
          @options[:url_swap][Regexp.new("^https://#{dom}")] = ''
          @options[:url_swap][Regexp.new("^//#{dom}")] = ''
        end
      end

      @failures = []
      @before_request = []
    end

    def run
      if @type == :links
        @logger.log :warn, "Running #{checks} on #{@src}... \n\n"
        check_list_of_links unless @options[:disable_external]
      else
        @logger.log :warn, "Running #{checks} on #{@src} on *#{@options[:extension]}... \n\n"
        @logger.log :warn, "Cache is set to #{@options[:cache].inspect}"
        check_files
        file_text = pluralize(files.length, 'file', 'files')
        @logger.log :warn, "Ran on #{file_text}!\n\n"
      end

      if @failures.empty?
        @logger.log :info, 'HTML-Proofer finished successfully.'
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
      @logger.log :info, "Checking #{@external_urls}"
      validate_urls
    end

    # Collects any external URLs found in a directory of files. Also collectes
    # every failed test from process_files.
    # Sends the external URLs to Typhoeus for batch processing.
    def check_files
      @external_urls = {}

      process_files.each do |item|
        @external_urls.merge!(item[:external_urls])
        @failures.concat(item[:failures])
      end

      # TODO: lazy. if we're checking only external links,
      # we'll just trash all the failed tests. really, we should
      # just not run those other checks at all.
      if @options[:external_only]
        @failures = []
        @logger.log :info, "Second validation of urls"
        validate_urls
      elsif !@options[:disable_external]
        @logger.log :info, "Third place for validation of urls"
        validate_urls
      end
    end

    # Walks over each implemented check and runs them on the files, in parallel.
    def process_files
      if @options[:parallel].empty?
        files.map { |path| check_path(path) }
      else
        begin
          Parallel.map(files, @options[:parallel]) { |path| check_path(path) }
        rescue => e
          @logger.log :warn, "Process #{Process.pid} failed"
          @logger.log :warn, e.backtrace
        end
      end
    end

    def check_parsed(html, path)
      result = { external_urls: {}, failures: [] }

      @src = [@src] if @type == :file

      @src.each do |src|
        checks.each do |klass|
          @logger.log :info, "Checking #{klass.to_s.downcase} on #{path} ..."
          check = Object.const_get(klass).new(src, path, html, @logger, @options)
          check.run
          external_urls = check.external_urls
          external_urls = Hash[check.external_urls.map { |url, file| [swap(url, @options[:url_swap]), file] }] if @options[:url_swap]
          result[:external_urls].merge!(external_urls)
          result[:failures].concat(check.issues)
        end
      end
      result
    end

    def check_path(path)
      check_parsed create_nokogiri(path), path
    end

    def validate_urls
      @logger.log :info, "Cache being made with #{@options[:cache]}"
      url_validator = HTMLProofer::UrlValidator.new(@logger, @external_urls, @options)
      cache = url_validator.cache?
      @logger.log :info, "We have a cache? #{cache.inspect}"
      @logger.log :info, "We have set up cache? #{cache.use_cache?}"
      url_validator.before_request = @before_request
      @failures.concat(url_validator.run)
      @external_urls = url_validator.external_urls
    end

    def files
      @files ||= if @type == :directory
                   @src.map do |src|
                     pattern = File.join(src, '**', "*#{@options[:extension]}")
                     files = Dir.glob(pattern).select { |fn| File.file? fn }
                     files.reject { |f| ignore_file?(f) }
                   end.flatten
                 elsif @type == :file && File.extname(@src) == @options[:extension]
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
      return @checks if defined?(@checks) && !@checks.nil?

      return (@checks = ['LinkCheck']) if @type == :links

      @checks = HTMLProofer::Check.subchecks.map(&:name)
      @checks.delete('FaviconCheck') unless @options[:check_favicon]
      @checks.delete('HtmlCheck') unless @options[:check_html]
      @checks.delete('OpenGraphCheck') unless @options[:check_opengraph]
      @options[:checks_to_ignore].each { |ignored| @checks.delete(ignored) }
      @checks
    end

    def failed_tests
      result = []
      return result if @failures.empty?

      @failures.each { |f| result << f.to_s }
      result
    end

    def print_failed_tests
      sorted_failures = SortedIssues.new(@failures, @options[:error_sort], @logger)

      sorted_failures.sort_and_report
      count = @failures.length
      failure_text = pluralize(count, 'failure', 'failures')
      raise @logger.colorize :fatal, "HTML-Proofer found #{failure_text}!"
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
      @before_request << block if block_given?
      @before_request
    end
  end
end
