# encoding: utf-8
class HTML::Proofer::Runner

  class Issue
    attr_reader :path, :desc, :status

    def initialize(path, desc, status = -1)
      @path = path
      @desc = desc
      @status = status
    end

    def to_s
      "#{@path}: #{desc}"
    end
  end
end
