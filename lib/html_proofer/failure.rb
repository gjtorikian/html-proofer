# frozen_string_literal: true

module HTMLProofer
  class Failure
    attr_reader :path, :check_name, :description, :status, :line, :content, :element

    def initialize(path, check_name, description, line: nil, status: nil, content: nil, element: nil)
      @path = path
      @check_name = check_name
      @description = description

      @line = line
      @status = status
      @content = content
      @element = element
    end
  end
end
