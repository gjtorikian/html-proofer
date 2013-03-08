require_relative '../test_helper'
 
describe Doc::Tester do
 
  it "must be defined" do
    Doc::Tester::VERSION.wont_be_nil
  end
 
end