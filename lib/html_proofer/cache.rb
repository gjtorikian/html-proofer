# frozen_string_literal: true

require 'date'
require 'json'
require 'uri'

module HTMLProofer
  class Cache
    include HTMLProofer::Utils

    CACHE_VERSION = 2

    DEFAULT_STORAGE_DIR = File.join('tmp', '.htmlproofer')
    DEFAULT_CACHE_FILE_NAME = 'cache.json'

    URI_REGEXP = URI::DEFAULT_PARSER.make_regexp

    attr_reader :exists, :cache_log, :storage_dir, :cache_file

    def initialize(runner, options)
      @runner = runner
      @logger = @runner.logger

      @cache_datetime = DateTime.now
      @cache_time = @cache_datetime.to_time

      if blank?(options)
        define_singleton_method(:enabled?) { false }
      else
        define_singleton_method(:enabled?) { true }
        setup_cache!(options)
        @parsed_timeframe = parsed_timeframe(options[:timeframe])
      end
    end

    def within_timeframe?(time)
      return false if time.nil?

      time = Time.parse(time) if time.is_a?(String)
      (@parsed_timeframe..@cache_time).cover?(time)
    end

    def parsed_timeframe(timeframe)
      time, date = timeframe.match(/(\d+)(\D)/).captures
      time = time.to_i
      case date
      when 'M'
        time_ago(time, :months)
      when 'w'
        time_ago(time, :weeks)
      when 'd'
        time_ago(time, :days)
      when 'h'
        time_ago(time, :hours)
      else
        raise ArgumentError, "#{date} is not a valid timeframe!"
      end
    end

    def add_internal(url, metadata, found)
      return unless enabled?

      @cache_log[:internal][url] = { time: @cache_time, metadata: [] } if @cache_log[:internal][url].nil?

      @cache_log[:internal][url][:metadata] << construct_internal_link_metadata(metadata, found)
    end

    def add_external(url, filenames, status_code, msg)
      return unless enabled?

      found = status_code.between?(200, 299)

      clean_url = cleaned_url(url)
      @cache_log[:external][clean_url] = { time: @cache_time.to_s, found: found, status_code: status_code, message: msg, metadata: filenames }
    end

    def detect_url_changes(urls_detected, type)
      additions = determine_additions(urls_detected, type)

      determine_deletions(urls_detected, type)

      additions
    end

    private def construct_internal_link_metadata(metadata, found)
      {
        source: metadata[:source],
        current_path: metadata[:current_path],
        line: metadata[:line],
        base_url: metadata[:base_url],
        found: found
      }
    end

    # prepare to add new URLs detected
    private def determine_additions(urls_detected, type)
      additions = urls_detected.reject do |url, metadata|
        if @cache_log[type].include?(url)
          @cache_log[type][url][:metadata] = metadata

          # if this is false, we're trying again
          if type == :external
            @cache_log[type][url][:found]
          else
            @cache_log[type][url][:metadata].none? { |m| m[:found] }
          end
        else
          @logger.log :debug, "Adding #{url} to #{type} cache"
          false
        end
      end

      new_link_count = additions.length
      new_link_text = pluralize(new_link_count, "new #{type} link", "new #{type} links")
      @logger.log :debug, "Adding #{new_link_text} to the cache"

      additions
    end

    # remove from cache URLs that no longer exist
    private def determine_deletions(urls_detected, type)
      deletions = 0

      @cache_log[type].delete_if do |url, _|
        if urls_detected.include?(url)
          false
        elsif url_matches_type?(url, type)
          @logger.log :debug, "Removing #{url} from #{type} cache"
          deletions += 1
          true
        end
      end

      del_link_text = pluralize(deletions, "outdated #{type} link", "outdated #{type} links")
      @logger.log :debug, "Removing #{del_link_text} from the cache"
    end

    def write
      return unless enabled?

      File.write(@cache_file, @cache_log.to_json)
    end

    def retrieve_urls(urls_detected, type)
      # if there are no urls, bail
      return {} if urls_detected.empty?

      urls_detected = urls_detected.transform_keys do |url|
        cleaned_url(url)
      end

      urls_to_check = detect_url_changes(urls_detected, type)

      @cache_log[type].each_pair do |url, cache|
        next if within_timeframe?(cache[:time])

        urls_to_check[url] = cache[:metadata] # recheck expired links
      end

      urls_to_check
    end

    def empty?
      blank?(@cache_log) || (@cache_log[:internal].empty? && @cache_log[:external].empty?)
    end

    def size(type)
      @cache_log[type].size
    end

    private def setup_cache!(options)
      default_structure = {
        version: CACHE_VERSION,
        internal: {},
        external: {}
      }

      @storage_dir = options[:storage_dir] || DEFAULT_STORAGE_DIR

      FileUtils.mkdir_p(storage_dir) unless Dir.exist?(storage_dir)

      cache_file_name = options[:cache_file] || DEFAULT_CACHE_FILE_NAME

      @cache_file = File.join(storage_dir, cache_file_name)

      return (@cache_log = default_structure) unless File.exist?(@cache_file)

      contents = File.read(@cache_file)

      return (@cache_log = default_structure) if blank?(contents)

      log = JSON.parse(contents, symbolize_names: true)

      old_cache = (cache_version = log[:version]).nil?
      @cache_log = if old_cache # previous cache version, create a new one
                     default_structure
                   elsif cache_version != CACHE_VERSION
                   # if cache version is newer...do something
                   else
                     log[:internal] = log[:internal].transform_keys(&:to_s)
                     log[:external] = log[:external].transform_keys(&:to_s)
                     log
                   end
    end

    private def time_ago(measurement, unit)
      case unit
      when :months
        @cache_datetime >> -measurement
      when :weeks
        @cache_datetime - (measurement * 7)
      when :days
        @cache_datetime - measurement
      when :hours
        @cache_datetime - Rational(measurement / 24.0)
      end.to_time
    end

    private def url_matches_type?(url, type)
      return true if type == :internal && url !~ URI_REGEXP
      return true if type == :external && url =~ URI_REGEXP
    end

    private def cleaned_url(url)
      cleaned_url = escape_unescape(url)

      return cleaned_url unless cleaned_url.end_with?('/', '#', '?') && cleaned_url.length > 1

      cleaned_url[0..-2]
    end

    private def escape_unescape(url)
      Addressable::URI.parse(url).normalize.to_s
    end
  end
end
