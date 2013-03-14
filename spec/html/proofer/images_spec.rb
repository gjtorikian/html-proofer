require "spec_helper"
include HTML::Proofer::Checks

describe "Image" do
  it "passes for existing external images" do
    externalImageFilepath = "#{FIXTURES_DIR}/existingImageExternal.html"
    @imageCheck = ::HTML::Proofer::Checks::Check::Images.new(externalImageFilepath, HTML::Proofer.create_nokogiri(externalImageFilepath))
    @imageCheck.run
    @imageCheck.issues[0].should eq(nil)
  end

  it "fails for image without alt attribute" do
    missingAltFilepath = "#{FIXTURES_DIR}/missingImageAlt.html"
    @imageCheck = ::HTML::Proofer::Checks::Check::Images.new(missingAltFilepath, HTML::Proofer.create_nokogiri(missingAltFilepath))
    @imageCheck.run
    @imageCheck.issues[0].should eq("In spec/html/proofer/fixtures/missingImageAlt.html, image ./gpl.png does not have an alt attribute")
  end

  it "fails for image without a dir prefix" do
    missingImageDirPrefixFilepath = "#{FIXTURES_DIR}/missingImageDirPrefix.html"
    @imageCheck = ::HTML::Proofer::Checks::Check::Images.new(missingImageDirPrefixFilepath, HTML::Proofer.create_nokogiri(missingImageDirPrefixFilepath))
    @imageCheck.run
    @imageCheck.issues[0].should eq("In spec/html/proofer/fixtures/missingImageDirPrefix.html, internal image /gpl.png does not exist")
  end

  it "fails for missing external images" do
    externalImageFilepath = "#{FIXTURES_DIR}/missingImageExternal.html"
    @imageCheck = ::HTML::Proofer::Checks::Check::Images.new(externalImageFilepath, HTML::Proofer.create_nokogiri(externalImageFilepath))
    @imageCheck.run
    @imageCheck.issues[0].should eq("In spec/html/proofer/fixtures/missingImageExternal.html, external image http://www.whatthehell does not exist")
  end

  it "fails for missing internal images" do
    internalImageFilepath = "#{FIXTURES_DIR}/missingImageInternal.html"
    @imageCheck = ::HTML::Proofer::Checks::Check::Images.new(internalImageFilepath, HTML::Proofer.create_nokogiri(internalImageFilepath))
    @imageCheck.run
    @imageCheck.issues[0].should eq("In spec/html/proofer/fixtures/missingImageInternal.html, internal image ./doesnotexist.png does not exist")
  end

  it "fails for image with no src" do
    imageSrcFilepath = "#{FIXTURES_DIR}/missingImageSrc.html"
    @imageCheck = ::HTML::Proofer::Checks::Check::Images.new(imageSrcFilepath, HTML::Proofer.create_nokogiri(imageSrcFilepath))
    @imageCheck.run
    @imageCheck.issues[0].should eq("In spec/html/proofer/fixtures/missingImageSrc.html, image has no src attribute")
  end
end