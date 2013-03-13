# encoding: utf-8

module HTML::Proofer::Checks

  class Check

    attr_reader :issues

    def initialize(path, html, opts)
      @path   = path
      @html   = html
      @options = opts
      @issues = Set.new
    end

    def run
      raise NotImplementedError.new("HTML::Proofer::Check subclasses must implement #run")
    end

    def add_issue(desc)
      @issues << desc
    end

    def output_filenames
      Dir[@site.config[:output_dir] + '/**/*'].select{ |f| File.file?(f) }
    end

    def self.subclasses
      classes = []

      ObjectSpace.each_object(Class) do |c|
        next unless c.superclass == self
        classes << c
      end

      classes
    end
  end
end
