require 'stat'
module HTMLProofer
  class Issue
    attr_reader :status, :finding, :content

    def initialize(path, desc, rule, line: nil, status: -1, content: nil)
      @status = status
      @content = content

      @finding = StatModule::Finding.new(true, rule, desc)
      location = StatModule::Location.new(path)
      unless line.nil?
        location.begin_line = line.to_i
        location.end_line = line.to_i
      end
      @finding.location = location
    end

    def path
      @finding.location.path
    end

    def desc
      @finding.description
    end

    def line
      if @finding.location.begin_line.nil?
        ''
      else
        " (line #{@finding.location.begin_line})"
      end
    end

    def to_s
      "#{path}: #{desc}#{line}"
    end
  end

  class SortedIssues
    include HTMLProofer::Utils

    attr_reader :issues

    def initialize(issues, error_sort, logger, is_stat)
      @issues = issues
      @error_sort = error_sort
      @logger = logger
      @is_stat = is_stat
    end

    def sort_and_report
      case @error_sort
        when :path
          sorted_issues = sort(:path, :desc)
          report(sorted_issues, :path, :desc)
        when :desc
          sorted_issues = sort(:desc, :path)
          report(sorted_issues, :desc, :path)
        when :status
          sorted_issues = sort(:status, :path)
          report(sorted_issues, :status, :path)
      end
    end

    def sort(first_sort, second_sort)
      issues.sort_by { |t| [t.send(first_sort), t.send(second_sort)] }
    end

    def report(sorted_issues, first_report, second_report)
      matcher = nil

      if @is_stat
        stat = init_stat
        sorted_issues.each do |issue|
          stat.findings.push(issue.finding)
        end
        puts stat.to_json
        return
      end

      sorted_issues.each do |issue|
        if matcher != issue.send(first_report)
          @logger.log :error, "- #{issue.send(first_report)}"
          matcher = issue.send(first_report)
        end
        if first_report == :status
          @logger.log :error, "  *  #{issue}"
        else
          msg = "  *  #{issue.send(second_report)}#{issue.line}"
          if !issue.content.nil? && !issue.content.empty?
            msg = "#{msg}\n     #{issue.content}"
          end
          @logger.log(:error, msg)
        end
      end
    end
  end
end
