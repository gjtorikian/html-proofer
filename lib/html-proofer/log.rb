require 'yell'
require 'colored'

module HTMLProofer
  class Log
    include Yell::Loggable


    def initialize(log_level, hide)
      if !hide
        @logger = Yell.new(format: false, \
                           name: 'HTMLProofer', \
                           level: "gte.#{log_level}") do |l|
          l.adapter :stdout, level: %i[debug info warn]
          l.adapter :stderr, level: %i[error fatal]
        end
      else
        @hide = true
      end
    end

    def log(level, message)
      return if @hide

      color = case level
              when :debug
                :light_blue
              when :info
                :blue
              when :warn
                :yellow
              when :error, :fatal
                :red
              end

      log_with_color(level, color, message)
    end

    def log_with_color(level, color, message)
      return if @hide

      @logger.send level, colorize(color, message)
    end

    def colorize(color, message)
      return message if @hide

      if $stdout.isatty && $stderr.isatty
        Colored.colorize(message, foreground: color)
      else
        message
      end
    end

    # dumb override to play nice with Typhoeus/Ethon
    def debug(message = nil)
      return if @hide

      log(:debug, message) unless message.nil?
    end
  end
end
