require 'stat'
module HTMLProofer
  class Issue < StatModule::Finding

    def initialize(path, desc, rule, line: nil, status: -1, content: nil)
      super(true, rule, desc)
      define_singleton_method(:status) { status }
      @detail = StatModule::Detail.new(content)

      @location = StatModule::Location.new(path)
      unless line.nil?
        @location.begin_line = line.to_i
        @location.end_line = line.to_i
      end
    end

    def path
      @location.path
    end

    def desc
      @description
    end

    def content
      @detail.body
    end

    def line
      if @location.begin_line.nil?
        ''
      else
        " (line #{@location.begin_line})"
      end
    end

    def to_s
      "#{path}: #{@description}#{line}"
    end
  end

  class SortedIssues
    attr_reader :issues

    def initialize(issues, error_sort, logger)
      @issues = issues
      @error_sort = error_sort
      @logger = logger
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

      sorted_issues.each do |issue|
        if matcher != issue.send(first_report)
          @logger.log :error, "- #{issue.send(first_report)}"  unless @logger.nil?
          matcher = issue.send(first_report)
        end
        if first_report == :status
          @logger.log :error, "  *  #{issue}"  unless @logger.nil?
        else
          msg = "  *  #{issue.send(second_report)}#{issue.line}"  unless @logger.nil?
          if !issue.content.nil? && !issue.content.empty?
            msg = "#{msg}\n     #{issue.content}"
          end
          @logger.log(:error, msg)  unless @logger.nil?
        end
      end
    end
  end
end
