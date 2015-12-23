require_relative 'utils'

require 'json'
require 'active_support/core_ext/string'
require 'active_support/core_ext/date'
require 'active_support/core_ext/numeric/time'

class HTMLProofer
  class Cache
    include HTMLProofer::Utils

    FILENAME = File.join(STORAGE_DIR, 'cache.log')

    attr_accessor :exists, :load, :cache_log, :cache_time

    def initialize(logger, options)
      @logger = logger
      @cache_log = {}

      if options.nil? || options.empty?
        @load = false
      else
        @load = true
        @parsed_timeframe = parsed_timeframe(options[:timeframe] || '30d')
      end
      @cache_time = Time.now

      if File.exist?(FILENAME)
        @exists = true
        contents = File.read(FILENAME)
        @cache_log = contents.empty? ? {} : JSON.parse(contents)
      else
        @exists = false
      end
    end

    def within_timeframe?(time)
      (@parsed_timeframe..@cache_time).cover?(time)
    end

    def urls
      @cache_log['urls'] || []
    end

    def parsed_timeframe(timeframe)
      time, date = timeframe.match(/(\d+)(\D)/).captures
      time = time.to_f
      case date
      when 'M'
        time.months.ago
      when 'w'
        time.weeks.ago
      when 'd'
        time.days.ago
      when 'h'
        time.hours.ago
      else
        fail ArgumentError, "#{date} is not a valid timeframe!"
      end
    end

    def add(url, filenames, status, msg = '')
      data = {
                :time => @cache_time,
                :filenames => filenames,
                :status => status,
                :message => msg
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
          @logger.log :debug, :yellow, "Adding #{url} to cache check"
          false
        end
      end

      new_link_count = additions.length
      new_link_text = pluralize(new_link_count, 'link', 'links')
      @logger.log :info, :blue, "Adding #{new_link_text} to the cache..."

      # remove from cache URLs that no longer exist
      del = 0
      @cache_log.delete_if do |url, _|
        url = clean_url(url)
        if !found_urls.include?(url)
          @logger.log :debug, :yellow, "Removing #{url} from cache check"
          del += 1
          true
        else
          false
        end
      end

      del_link_text = pluralize(del, 'link', 'links')
      @logger.log :info, :blue, "Removing #{del_link_text} from the cache..."

      additions
    end

    def write
      File.write(FILENAME, @cache_log.to_json)
    end

    def load?
      @load.nil?
    end


    # FIXME: there seems to be some discrepenacy where Typhoeus occasionally adds
    # a trailing slash to URL strings, which causes issues with the cache
    def slashless_url(url)
      url.chomp('/')
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
      slashless_url(unescape_url(url))
    end
  end
end
