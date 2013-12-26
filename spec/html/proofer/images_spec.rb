require "spec_helper"

describe "Image tests" do
  it "passes for existing external images" do
    externalImageFilepath = "#{FIXTURES_DIR}/existingImageExternal.html"
    @imageCheck = Images.new("#{FIXTURES_DIR}", externalImageFilepath, HTML::Proofer.create_nokogiri(externalImageFilepath))
    @imageCheck.run
    @imageCheck.issues[0].should eq(nil)
  end

  it "fails for image without alt attribute" do
    missingAltFilepath = "#{FIXTURES_DIR}/missingImageAlt.html"
    @imageCheck = Images.new("#{FIXTURES_DIR}", missingAltFilepath, HTML::Proofer.create_nokogiri(missingAltFilepath))
    @imageCheck.run
    @imageCheck.issues[0].should eq("spec/html/proofer/fixtures/missingImageAlt.html".blue + ": image ./gpl.png does not have an alt attribute")
  end

  it "fails for image with an empty alt attribute" do
    missingAltFilepath = "#{FIXTURES_DIR}/missingImageAltText.html"
    @imageCheck = Images.new("#{FIXTURES_DIR}", missingAltFilepath, HTML::Proofer.create_nokogiri(missingAltFilepath))
    @imageCheck.run
    @imageCheck.issues[0].should eq("spec/html/proofer/fixtures/missingImageAltText.html".blue + ": image ./gpl.png does not have an alt attribute")
  end

  it "fails for missing external images" do
    externalImageFilepath = "#{FIXTURES_DIR}/missingImageExternal.html"
    lambda { @imageCheck = HTML::Proofer.new(externalImageFilepath).run }.should raise_error SystemExit
  end

  it "fails for missing internal images" do
    internalImageFilepath = "#{FIXTURES_DIR}/missingImageInternal.html"
    @imageCheck = Images.new("#{FIXTURES_DIR}", internalImageFilepath, HTML::Proofer.create_nokogiri(internalImageFilepath))
    @imageCheck.run
    @imageCheck.issues[0].should eq("spec/html/proofer/fixtures/missingImageInternal.html".blue + ": internal image ./doesnotexist.png does not exist")
  end

  it "fails for image with no src" do
    imageSrcFilepath = "#{FIXTURES_DIR}/missingImageSrc.html"
    @imageCheck = Images.new("#{FIXTURES_DIR}", imageSrcFilepath, HTML::Proofer.create_nokogiri(imageSrcFilepath))
    @imageCheck.run
    @imageCheck.issues[0].should eq("spec/html/proofer/fixtures/missingImageSrc.html".blue + ": image has no src attribute")
  end

  it "fails for image with default mac filename" do
    terribleImageName = "#{FIXTURES_DIR}/terribleImageName.html"
    @imageCheck = Images.new("#{FIXTURES_DIR}", terribleImageName, HTML::Proofer.create_nokogiri(terribleImageName))
    @imageCheck.run
    @imageCheck.issues[0].should eq("spec/html/proofer/fixtures/terribleImageName.html".blue + ": image has a terrible filename (./Screen Shot 2012-08-09 at 7.51.18 AM.png)")
  end

  it 'ignores images marked as ignore data-proofer-ignore' do
    ignorableImages = "#{FIXTURES_DIR}/ignorableImages.html"
    @imageCheck = Images.new("#{FIXTURES_DIR}", ignorableImages, HTML::Proofer.create_nokogiri(ignorableImages))
    @imageCheck.run
    @imageCheck.issues[0].should eq(nil)
  end

  it 'properly checks relative links' do
    relativeLinks = "#{FIXTURES_DIR}/relativeLinks.html"
    @imageCheck = Images.new("#{FIXTURES_DIR}", relativeLinks, HTML::Proofer.create_nokogiri(relativeLinks))
    @imageCheck.run
    @imageCheck.issues[0].should eq(nil)

    relativeLinks = "#{FIXTURES_DIR}/resources/books/index.html"
    @imageCheck = Images.new("#{FIXTURES_DIR}", relativeLinks, HTML::Proofer.create_nokogiri(relativeLinks))
    @imageCheck.run
    @imageCheck.issues[0].should eq(nil)
  end
end
