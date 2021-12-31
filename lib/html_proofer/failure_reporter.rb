# frozen_string_literal: true

module HTMLProofer
  class FailureReporter
    include HTMLProofer::Utils

    attr_reader :failures

    def initialize(failures, logger)
      @failures = failures
      @logger = logger
      @sorted_failures = failures.group_by(&:check_name) \
                                  .transform_values { |issues| issues.sort_by { |issue| [issue.path, issue.line] } } \
                                  .sort
    end

    def report(type)
      case type
      when :cli
        cli_report
      end
    end

    def cli_report
      msg = @sorted_failures.each_with_object([]) do |(check_name, failures), arr|
        str = ["For the #{check_name} check, the following failures were found:\n"]

        failures.each do |failure|
          path_str = blank?(failure.path) ? '' : "* In #{failure.path}"

          line_str = failure.line.nil? ? '' : " on line #{failure.line}"

          str << <<~MSG
            #{path_str}#{line_str}:

               #{failure.desc}
          MSG
        end

        arr << str.join("\n")
      end

      @logger.log(:error, msg.join("\n"))
    end
  end
end
