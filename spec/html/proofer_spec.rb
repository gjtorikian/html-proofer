require "spec_helper"

describe HTML::Proofer do
  describe "#failed_tests" do
    it "is a list of the formatted errors" do
      brokenLinkInternalFilepath = "#{FIXTURES_DIR}/links/brokenLinkInternal.html"
      proofer = HTML::Proofer.new(brokenLinkInternalFilepath)
      capture_stderr { proofer.run }
      proofer.failed_tests.should eq(["\e[34mspec/html/proofer/fixtures/links/brokenLinkInternal.html\e[0m: internally linking to ./notreal.html, which does not exist", "\e[34mspec/html/proofer/fixtures/links/brokenLinkInternal.html\e[0m: internally linking to ./missingImageAlt.html, which does not exist"])
    end
  end
end
