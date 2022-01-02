# frozen_string_literal: true

class HTMLProofer::Reporter::Cli < HTMLProofer::Reporter
  def report
    msg = failures.each_with_object([]) do |(check_name, failures), arr|
      str = ["For the #{check_name} check, the following failures were found:\n"]

      failures.each do |failure|
        path_str = blank?(failure.path) ? '' : "* In #{failure.path}"

        line_str = failure.line.nil? ? '' : " (line #{failure.line})"

        status_str = failure.status.nil? ? '' : " (#{failure.status})"

        str << <<~MSG
          #{path_str}#{line_str}:

             #{failure.description}#{status_str}
        MSG
      end

      arr << str.join("\n")
    end

    @logger.log(:error, msg.join("\n"))
  end
end
