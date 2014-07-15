require "spec_helper"

describe "Scripts tests" do

  it "fails for broken external src" do
    file = "#{FIXTURES_DIR}/script_broken_external.html"
    output = capture_stderr { HTML::Proofer.new(file).run }
    output.should match /External link http:\/\/www.asdo3IRJ395295jsingrkrg4.com\/asdo3IRJ.js? failed: 0 Couldn't resolve host name/
  end

  it "works for valid internal src" do
    file = "#{FIXTURES_DIR}/script_valid_internal.html"
    output = capture_stderr { HTML::Proofer.new(file).run }
    output.should == ""
  end

  it "fails for missing internal src" do
    file = "#{FIXTURES_DIR}/script_missing_internal.html"
    output = capture_stderr { HTML::Proofer.new(file).run }
    output.should match /doesnotexist.js does not exist/
  end

  it "works for present content" do
    file = "#{FIXTURES_DIR}/script_content.html"
    output = capture_stderr { HTML::Proofer.new(file).run }
    output.should == ""
  end

  it "fails for absent content" do
    file = "#{FIXTURES_DIR}/script_content_absent.html"
    output = capture_stderr { HTML::Proofer.new(file).run }
    output.should match /script is empty and has no src attribute/
  end

end
