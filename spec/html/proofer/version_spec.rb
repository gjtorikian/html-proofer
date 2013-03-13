require "spec_helper"

describe HTML::Proofer do

  it "must be defined" do
    HTML::Proofer::VERSION.should_not be_nil
  end

end