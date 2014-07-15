require "spec_helper"

describe "Scripts tests" do

  it "fails for broken external src" do
    file = "#{FIXTURES_DIR}/script_broken_external.html"
    output = capture_stderr { HTML::Proofer.new(file).run }
    output.should match /External link http:\/\/www.asdo3IRJ395295jsingrkrg4.com\/asdo3IRJ.js? failed: 0 Couldn't resolve host name/
  end

end
