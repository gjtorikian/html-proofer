require "spec_helper"

describe "Image tests" do
  it "passes for existing external images" do
    externalImageFilepath = "#{FIXTURES_DIR}/existingImageExternal.html"
    @imageCheck = Images.new(externalImageFilepath, HTML::Proofer.create_nokogiri(externalImageFilepath))
    @imageCheck.run
    @imageCheck.issues[0].should eq(nil)
  end

  it "fails for image without alt attribute" do
    missingAltFilepath = "#{FIXTURES_DIR}/missingImageAlt.html"
    @imageCheck = Images.new(missingAltFilepath, HTML::Proofer.create_nokogiri(missingAltFilepath))
    @imageCheck.run
    @imageCheck.issues[0].should eq("spec/html/proofer/fixtures/missingImageAlt.html".blue + ": image ./gpl.png does not have an alt attribute")
  end

  it "fails for image with an empty alt attribute" do
    missingAltFilepath = "#{FIXTURES_DIR}/missingImageAltText.html"
    @imageCheck = Images.new(missingAltFilepath, HTML::Proofer.create_nokogiri(missingAltFilepath))
    @imageCheck.run
    @imageCheck.issues[0].should eq("spec/html/proofer/fixtures/missingImageAltText.html".blue + ": image ./gpl.png does not have an alt attribute")
  end

  it "fails for image without a dir prefix" do
    missingImageDirPrefixFilepath = "#{FIXTURES_DIR}/missingImageDirPrefix.html"
    @imageCheck = Images.new(missingImageDirPrefixFilepath, HTML::Proofer.create_nokogiri(missingImageDirPrefixFilepath))
    @imageCheck.run
    @imageCheck.issues[0].should eq("spec/html/proofer/fixtures/missingImageDirPrefix.html".blue + ": internal image /gpl.png does not exist")
  end

  it "fails for missing external images" do
    externalImageFilepath = "#{FIXTURES_DIR}/missingImageExternal.html"
    @imageCheck = Images.new(externalImageFilepath, HTML::Proofer.create_nokogiri(externalImageFilepath))
    @imageCheck.run
    @imageCheck.hydra.run
    @imageCheck.issues[0].sub!(/ #<Typhoeus::Response:[\w]+>/, "")
    @imageCheck.issues[0].should eq("spec/html/proofer/fixtures/missingImageExternal.html".blue + ": external image http://www.whatthehell does not exist")
  end

  it "fails for missing internal images" do
    internalImageFilepath = "#{FIXTURES_DIR}/missingImageInternal.html"
    @imageCheck = Images.new(internalImageFilepath, HTML::Proofer.create_nokogiri(internalImageFilepath))
    @imageCheck.run
    @imageCheck.issues[0].should eq("spec/html/proofer/fixtures/missingImageInternal.html".blue + ": internal image ./doesnotexist.png does not exist")
  end

  it "fails for image with no src" do
    imageSrcFilepath = "#{FIXTURES_DIR}/missingImageSrc.html"
    @imageCheck = Images.new(imageSrcFilepath, HTML::Proofer.create_nokogiri(imageSrcFilepath))
    @imageCheck.run
    @imageCheck.issues[0].should eq("spec/html/proofer/fixtures/missingImageSrc.html".blue + ": image has no src attribute")
  end

  it "fails for image with default mac filename" do
    terribleImageName = "#{FIXTURES_DIR}/terribleImageName.html"
    @imageCheck = Images.new(terribleImageName, HTML::Proofer.create_nokogiri(terribleImageName))
    @imageCheck.run
    @imageCheck.issues[0].should eq("spec/html/proofer/fixtures/terribleImageName.html".blue + ": image has a terrible filename (./Screen Shot 2012-08-09 at 7.51.18 AM.png)")
  end
end
