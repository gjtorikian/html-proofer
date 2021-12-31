# frozen_string_literal: true

module HTMLProofer
  class Failure
    attr_reader :path, :check_name, :desc, :status, :line, :content

    def initialize(path, check_name, desc, line: nil, status: nil, content: nil)
      @path = path
      @check_name = check_name
      @desc = desc

      @line = line
      @status = status
      @content = content
    end

    def to_s
      if @line
        "#{@path}: #{@desc} (line #{@line})"
      else
        "#{@path}: #{@desc}"
      end
    end
  end
end
