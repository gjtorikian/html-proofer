# frozen_string_literal: true

require_relative 'utils'
require 'date'
require 'json'

module HTMLProofer
  class Cache
    include HTMLProofer::Utils

    DEFAULT_STORAGE_DIR = File.join('tmp', '.htmlproofer')
    DEFAULT_CACHE_FILE_NAME = 'cache.log'

    attr_reader :exists, :cache_log, :storage_dir, :cache_file

    def initialize(logger, options)
      @logger = logger
      @cache_log = {}

      @cache_datetime = DateTime.now
      @cache_time = @cache_datetime.to_time

      if options.nil? || options.empty?
        define_singleton_method('use_cache?') { false }
      else
        define_singleton_method('use_cache?') { true }
        setup_cache!(options)
        @parsed_timeframe = parsed_timeframe(options[:timeframe])
      end
    end

    def within_timeframe?(time)
      (@parsed_timeframe..@cache_time).cover?(Time.parse(time))
    end

    def urls
      @cache_log['urls'] || []
    end

    def size
      @cache_log.length
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

    def add(url, filenames, status, msg = '')
      data = {
        time: @cache_time,
        filenames: filenames,
        status: status,
        message: msg
      }

      @cache_log[clean_url(url)] = data
    end

    def detect_url_changes(found)
      existing_urls = @cache_log.keys.map { |url| clean_url(url) }
      found_urls = found.keys.map { |url| clean_url(url) }

      # prepare to add new URLs detected
      additions = found.reject do |url, _|
        url = clean_url(url)
        if existing_urls.include?(url)
          true
        else
          @logger.log :debug, "Adding #{url} to cache check"
          false
        end
      end

      new_link_count = additions.length
      new_link_text = pluralize(new_link_count, 'link', 'links')
      @logger.log :info, "Adding #{new_link_text} to the cache..."

      # remove from cache URLs that no longer exist
      del = 0
      @cache_log.delete_if do |url, _|
        url = clean_url(url)
        if !found_urls.include?(url)
          @logger.log :debug, "Removing #{url} from cache check"
          del += 1
          true
        else
          false
        end
      end

      del_link_text = pluralize(del, 'link', 'links')
      @logger.log :info, "Removing #{del_link_text} from the cache..."

      additions
    end

    def write
      File.write(cache_file, @cache_log.to_json)
    end

    def load?
      @load.nil?
    end

    def retrieve_urls(external_urls)
      urls_to_check = detect_url_changes(external_urls)
      @cache_log.each_pair do |url, cache|
        if within_timeframe?(cache['time'])
          next if cache['message'].empty? # these were successes to skip
        else
          urls_to_check[url] = cache['filenames'] # recheck expired links
        end
      end
      urls_to_check
    end

    # FIXME: it seems that Typhoeus actually acts on escaped URLs,
    # but there's no way to get at that information, and the cache
    # stores unescaped URLs. Because of this, some links, such as
    # github.com/search/issues?q=is:open+is:issue+fig are not matched
    # as github.com/search/issues?q=is%3Aopen+is%3Aissue+fig
    def unescape_url(url)
      Addressable::URI.unescape(url)
    end

    def clean_url(url)
      unescape_url(url)
    end

    def setup_cache!(options)
      @storage_dir = options[:storage_dir] || DEFAULT_STORAGE_DIR

      FileUtils.mkdir_p(storage_dir) unless Dir.exist?(storage_dir)

      cache_file_name = options[:cache_file] || DEFAULT_CACHE_FILE_NAME

      @cache_file = File.join(storage_dir, cache_file_name)

      return unless File.exist?(cache_file)

      contents = File.read(cache_file)
      @cache_log = contents.empty? ? {} : JSON.parse(contents)
    end

    private

    def time_ago(measurement, unit)
      case unit
      when :months
        @cache_datetime >> -measurement
      when :weeks
        @cache_datetime - measurement * 7
      when :days
        @cache_datetime - measurement
      when :hours
        @cache_datetime - Rational(measurement / 24.0)
      end.to_time
    end
  end
end
