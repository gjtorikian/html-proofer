require_relative 'utils'

require 'json'
require 'active_support/core_ext/string'
require 'active_support/core_ext/date'
require 'active_support/core_ext/numeric/time'

module HTML
  class Proofer
    class Cache
      include HTML::Proofer::Utils

      FILENAME = File.join(STORAGE_DIR, 'cache.log')

      attr_accessor :exists, :load, :cache_log, :cache_time

      def initialize(options)
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

        @cache_log[url] = data
      end

      def detect_url_changes(found)
        existing_urls = @cache_log.keys
        found_urls = found.keys
        # prepare to add new URLs detected
        additions = found.reject { |k, _| existing_urls.include?(k) }
        # prepare to remove from cache URLs that no longer exist
        @cache_log.delete_if { |k, _| !found_urls.include?(k.chomp('/')) }

        additions
      end

      def write
        File.write(FILENAME, @cache_log.to_json)
      end

      def load?
        @load.nil?
      end
    end
  end
end
