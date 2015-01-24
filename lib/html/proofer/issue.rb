# encoding: utf-8
require 'colored'

class HTML::Proofer::Checks

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
