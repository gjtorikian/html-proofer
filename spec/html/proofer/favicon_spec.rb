require "spec_helper"

describe "Favicon tests" do
  it "ignores for absent favicon by default" do
    absent = "#{FIXTURES_DIR}/favicon_absent.html"
    output = capture_stderr { HTML::Proofer.new(absent).run }
    output.should == ""
  end

  it "fails for absent favicon" do
    absent = "#{FIXTURES_DIR}/favicon_absent.html"
    output = capture_stderr { HTML::Proofer.new(absent, {:favicon => true}).run }
    output.should match /no favicon included/
  end

  it "fails for absent favicon but present apple touch icon" do
    absent = "#{FIXTURES_DIR}/favicon_absent_apple.html"
    output = capture_stderr { HTML::Proofer.new(absent, {:favicon => true}).run }
    output.should match /no favicon included/
  end

  it "passes for present favicon" do
    present = "#{FIXTURES_DIR}/favicon_present.html"
    output = capture_stderr { HTML::Proofer.new(present, {:favicon => true}).run }
    output.should == ""
  end

  it "passes for present favicon with shortcut notation" do
    present = "#{FIXTURES_DIR}/favicon_present_shortcut.html"
    output = capture_stderr { HTML::Proofer.new(present, {:favicon => true}).run }
    output.should == ""
  end

end
