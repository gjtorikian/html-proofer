require "spec_helper"
include HTML::Proofer::Checks

describe "Image" do
  before :all do
      @htmlProofer = ::HTML::Proofer.new(" ")
  end

  it "must fail for image with no src" do
    imageSrcFilepath = "#{FIXTURES_DIR}/missingImageSrc.html"
    @imageCheck = ::HTML::Proofer::Checks::Check::Images.new(imageSrcFilepath, @htmlProofer.create_nokogiri(imageSrcFilepath))
    @imageCheck.run
    @imageCheck.issues[0].should eq("In spec/html/proofer/fixtures/missingImageSrc.html, image has no src attribute")
  end

  it "must fail for missing internal images" do
    internalImageFilepath = "#{FIXTURES_DIR}/missingInternalImage.html"
    @imageCheck = ::HTML::Proofer::Checks::Check::Images.new(internalImageFilepath, @htmlProofer.create_nokogiri(internalImageFilepath))
    @imageCheck.run
    @imageCheck.issues[0].should eq("In spec/html/proofer/fixtures/missingInternalImage.html, image ./doesnotexist.png does not exist")
  end

end