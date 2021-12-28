# frozen_string_literal: true

class HTMLProofer::Element::OpenGraph < HTMLProofer::Element
  attr_reader :src

  def initialize(obj, check, logger)
    super(obj, check, logger)
    # Fake up src from the content attribute
    instance_variable_set(:@src, @content)

    @src.insert 0, 'http:' if %r{^//}.match?(@src)
  end
end
