require "spec_helper"
include HTML::Proofer::Checks

describe "Links" do
  before :all do
      @htmlProofer = ::HTML::Proofer.new(" ")
  end

  it "fails for link with no href" do
    missingLinkHrefFilepath = "#{FIXTURES_DIR}/missingLinkHref.html"
    @linkCheck = ::HTML::Proofer::Checks::Check::Links.new(missingLinkHrefFilepath, @htmlProofer.create_nokogiri(missingLinkHrefFilepath))
    @linkCheck.run
    @linkCheck.issues[0].should eq("In spec/html/proofer/fixtures/missingLinkHref.html, link has no href attribute")
  end
end