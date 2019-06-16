# frozen_string_literal: true

require 'yell'
require 'rainbow'

module HTMLProofer
  class Log
    include Yell::Loggable

    def initialize(log_level)
      @logger = Yell.new(format: false, \
                         name: 'HTMLProofer', \
                         level: "gte.#{log_level}") do |l|
        l.adapter :stdout, level: %i[debug info warn]
        l.adapter :stderr, level: %i[error fatal]
      end
    end

    def log(level, message)
      color = case level
              when :debug
                :cyan
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
      @logger.send level, colorize(color, message)
    end

    def colorize(color, message)
      if $stdout.isatty && $stderr.isatty
        Rainbow(message).send(color)
      else
        message
      end
    end

    # dumb override to play nice with Typhoeus/Ethon
    def debug(message = nil)
      log(:debug, message) unless message.nil?
    end
  end
end
