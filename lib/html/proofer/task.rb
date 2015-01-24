class HTML::Proofer::Task < Rake::TaskLib

  attr_accessor :name, :src, :verbose

  def initialize name = :proofer, src
    @name = name
    @src  = src
    @verbose = Rake.application.options.trace

    yield self if block_given?

    define
  end

  def define
    desc "Test HTML files in: #{src}"
    task name do
      require 'html/proofer'
      HTML::Proofer.new(src, {:verbose => verbose}).run
    end
    self
  end
end
