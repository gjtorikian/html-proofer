require 'yell'
require 'colored'

class HTMLProofer
  class Log
    include Yell::Loggable

    def initialize(verbose, verbosity = nil)
      log_level = if verbosity.nil?
                    verbose ? :debug : :info
                  else
                    verbosity
                  end

      @logger = Yell.new(:format => false, \
                         :name => 'HTMLProofer', \
                         :level => "gte.#{log_level}") do |l|
        l.adapter :stdout, :level => [:debug, :info, :warn]
        l.adapter :stderr, :level => [:error, :fatal]
      end
    end

    def log(level, color, message)
      @logger.send level, colorize(color, message)
    end

    def colorize(color, message)
      if $stdout.isatty && $stderr.isatty
        Colored.colorize(message, foreground: color)
      else
        message
      end
    end

    # dumb override to play nice with Typhoeus/Ethon
    def debug(message = nil)
      log(:debug, :yellow, message) unless message.nil?
    end
  end
end
