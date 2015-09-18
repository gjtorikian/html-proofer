require 'json'

module HTML
  class Proofer
    class Cache
      attr_reader :status

      FILENAME = '.htmlproofer.log'

      def initialize(now, options)
        @status = {}
        @now = now
        @status[:time] = @now
        @status[:urls] = []

        if options.nil? || options.empty?
          @store = false
        else
          @store = true
          @timeframe = options[:timeframe]
        end

        if File.exist?(FILENAME)
          @exists = true
          @cache_log = JSON.parse(File.read(FILENAME))
        else
          @exists = false
        end
      end

      def store?
        @store
      end

      def exists?
        @exists && within_timeframe
      end

      def within_timeframe

      end

      def load

      end

      def add(url, status)
        return unless store?
        @status[:urls] << { :url => url, :status => status }
      end

      def write
        File.write(FILENAME, @status.to_json)
      end
    end
  end
end
