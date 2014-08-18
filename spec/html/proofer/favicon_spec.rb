require "spec_helper"

describe "Favicons test" do
  it "ignores for absent favicon by default" do
    absent = "#{FIXTURES_DIR}/favicon/favicon_absent.html"
    output = capture_stderr { HTML::Proofer.new(absent).run }
    output.should == ""
  end

  it "fails for absent favicon" do
    absent = "#{FIXTURES_DIR}/favicon/favicon_absent.html"
    output = capture_stderr { HTML::Proofer.new(absent, {:favicon => true}).run }
    output.should match /no favicon specified/
  end

  it "fails for absent favicon but present apple touch icon" do
    absent = "#{FIXTURES_DIR}/favicon/favicon_absent_apple.html"
    output = capture_stderr { HTML::Proofer.new(absent, {:favicon => true}).run }
    output.should match /no favicon specified/
  end

  it "fails for broken favicon" do
    broken = "#{FIXTURES_DIR}/favicon/favicon_broken.html"
    output = capture_stderr { HTML::Proofer.new(broken, {:favicon => true}).run }
    output.should match /internally linking to asdadaskdalsdk.png/
  end

  it "passes for present favicon" do
    present = "#{FIXTURES_DIR}/favicon/favicon_present.html"
    output = capture_stderr { HTML::Proofer.new(present, {:favicon => true}).run }
    output.should == ""
  end

  it "passes for present favicon with shortcut notation" do
    present = "#{FIXTURES_DIR}/favicon/favicon_present_shortcut.html"
    output = capture_stderr { HTML::Proofer.new(present, {:favicon => true}).run }
    output.should == ""
  end

  it "fails for broken favicon with data-proofer-ignore" do
    broken_but_ignored = "#{FIXTURES_DIR}/favicon/favicon_broken_but_ignored.html"
    output = capture_stderr { HTML::Proofer.new(broken_but_ignored, {:favicon => true}).run }
    output.should match /no favicon specified/
  end

end
