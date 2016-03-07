module HTMLProofer
  class Runner
    include HTMLProofer::Utils

    attr_reader :options, :external_urls

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

      if !@options[:cache].empty? && !File.exist?(STORAGE_DIR)
        FileUtils.mkdir_p(STORAGE_DIR)
      end

      @failures = []
    end

    def run
      @logger.log :info, "Running #{checks} on #{@src} on *#{@options[:extension]}... \n\n"

      if @type == :links
        check_list_of_links unless @options[:disable_external]
      else
        check_files
        file_text = pluralize(files.length, 'file', 'files')
        @logger.log :info, "Ran on #{file_text}!\n\n"
      end

      if @failures.empty?
        @logger.log_with_color :info, :green, 'HTML-Proofer finished successfully.'
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
        validate_urls
      elsif !@options[:disable_external]
        validate_urls
      end
    end

    # Walks over each implemented check and runs them on the files, in parallel.
    def process_files
      if @options[:parallel].empty?
        files.map { |path| check_path(path) }
      else
        Parallel.map(files, @options[:parallel]) { |path| check_path(path) }
      end
    end

    def check_path(path)
      result = { :external_urls => {}, :failures => [] }
      html = create_nokogiri(path)

      @src = [@src] if @type == :file

      @src.each do |src|
        checks.each do |klass|
          @logger.log :debug, "Checking #{klass.to_s.downcase} on #{path} ..."
          check = Object.const_get(klass).new(src, path, html, @options)
          check.run
          external_urls = check.external_urls
          if @options[:url_swap]
            external_urls = Hash[check.external_urls.map { |url, file| [swap(url, @options[:url_swap]), file] }]
          end
          result[:external_urls].merge!(external_urls)
          result[:failures].concat(check.issues)
        end
      end
      result
    end

    def validate_urls
      url_validator = HTMLProofer::UrlValidator.new(@logger, @external_urls, @options)
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
      return @checks unless @checks.nil?
      @checks = HTMLProofer::Check.subchecks.map(&:name)
      @checks.delete('FaviconCheck') unless @options[:check_favicon]
      @checks.delete('HtmlCheck') unless @options[:check_html]
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
      fail @logger.colorize :red, "HTML-Proofer found #{failure_text}!"
    end
  end
end
