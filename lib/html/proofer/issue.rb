# encoding: utf-8
require 'colored'

class HTML::Proofer::Checks

  class Issue

    attr_reader :path, :desc, :status

    def initialize(path, desc, status = nil)
      @path = path
      @desc = desc
      @status = status
    end

    def to_s
      "#{@path.blue}: #{desc}"
    end

  end
end
