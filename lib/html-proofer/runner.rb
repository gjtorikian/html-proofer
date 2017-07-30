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
      @logger = HTMLProofer::Log.new(@options[:log_level]) unless @options[:stat]

      # Add swap patterns for internal domains
      unless @options[:internal_domains].empty?
        @options[:internal_domains].each do |dom|
          @options[:url_swap][Regexp.new("^http://#{dom}")] = ''
          @options[:url_swap][Regexp.new("^https://#{dom}")] = ''
          @options[:url_swap][Regexp.new("^//#{dom}")] = ''
        end
      end
    end

    def run
      @stat = init_stat
      if @options[:stat]
        @stat.print_header
      end

      @logger.log :info, "Running #{checks} on #{@src} on *#{@options[:extension]}... \n\n" unless @logger.nil?

      if @type == :links
        check_list_of_links unless @options[:disable_external]
      else
        check_files
        file_text = pluralize(files.length, 'file', 'files')
        @logger.log :info, "Ran on #{file_text}!\n\n" unless @logger.nil?
      end

      if @options[:stat]
        @stat.print_footer
        return
      end

      if @stat.findings.empty?
        @logger.log_with_color :info, :green, 'HTML-Proofer finished successfully.' unless @logger.nil?
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
      end

      # TODO: lazy. if we're checking only external links,
      # we'll just trash all the failed tests. really, we should
      # just not run those other checks at all.
      if @options[:external_only]
        @stat = init_stat
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
      result = { external_urls: {}, failures: [] }
      html = create_nokogiri(path)

      @src = [@src] if @type == :file

      @src.each do |src|
        checks.each do |klass|
          @logger.log :debug, "Checking #{klass.to_s.downcase} on #{path} ..." unless @logger.nil?
          check = Object.const_get(klass).new(@stat, src, path, html, @options)
          check.run
          external_urls = check.external_urls
          if @options[:url_swap]
            external_urls = Hash[check.external_urls.map { |url, file| [swap(url, @options[:url_swap]), file] }]
          end
          result[:external_urls].merge!(external_urls)
        end
      end
      result
    end

    def validate_urls
      url_validator = HTMLProofer::UrlValidator.new(@logger, @external_urls, @options, @stat)
      url_validator.run
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
      @checks = HTMLProofer::Check.subchecks.map(&:name)
      @checks.delete('FaviconCheck') unless @options[:check_favicon]
      @checks.delete('HtmlCheck') unless @options[:check_html]
      @checks.delete('OpenGraphCheck') unless @options[:check_opengraph]
      @options[:checks_to_ignore].each { |ignored| @checks.delete(ignored) }
      @checks
    end

    def failed_tests
      result = []
      return result if @stat.findings.empty?
      @stat.findings.each { |f| result << f.to_s }
      result
    end

    def print_failed_tests
      sorted_failures = SortedIssues.new(@stat.findings, @options[:error_sort], @logger)

      sorted_failures.sort_and_report
      count = @stat.findings.length
      failure_text = pluralize(count, 'failure', 'failures')
      raise @logger.colorize :red, "HTML-Proofer found #{failure_text}!"
    end
  end
end
