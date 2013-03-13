require "test_helper"
 
describe HTML::Proofer do
 
  it "must be defined" do
    HTML::Proofer::VERSION.wont_be_nil
  end
 
end