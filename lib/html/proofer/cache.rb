require 'json'
require 'active_support'
require 'active_support/core_ext/date'
require 'active_support/core_ext/numeric/time'

module HTML
  class Proofer
    class Cache
      attr_reader :status

      FILENAME = '.htmlproofer.log'
      DURATIONS = %w(y M w d h)

      def initialize(options)
        @status = {}
        @status[:time] = Time.now
        @status[:urls] = []

        if options.nil? || options.empty?
          @load = false
        else
          @load = true
          @timeframe = options[:timeframe] || '30d'
        end

        if File.exist?(FILENAME)
          @exists = true
          @cache_log = JSON.parse(File.read(FILENAME))
        else
          @exists = false
        end
      end

      def exists?
        @exists && within_timeframe?
      end

      def within_timeframe?
        return false if @timeframe.nil?
        (parsed_timeframe..@status[:time]).cover?(cache_log_timestamp)
      end

      def load
        @cache_log['urls']
      end

      def parsed_timeframe
        time, date = @timeframe.match(/(\d+)(\D)/).captures
        unless DURATIONS.include?(date)
          fail ArgumentError, "#{date} is not a valid date in #{DURATIONS}!"
        end
        time = time.to_f
        case date
        when 'y'
          time.years.ago
        when 'M'
          time.months.ago
        when 'w'
          time.weeks.ago
        when 'd'
          time.days.ago
        when 'h'
          time.hours.ago
        end
      end

      def add(url, filenames, status, msg = '')
        @status[:urls] << { :url => url, :filenames => filenames, :status => status, :message => msg }
      end

      def write
        File.write(FILENAME, @status.to_json)
      end

      def load?
        @load.nil?
      end

      def cache_log_timestamp
        @cache_log_timestamp ||= Date.strptime(@cache_log['time'])
      end
    end
  end
end
