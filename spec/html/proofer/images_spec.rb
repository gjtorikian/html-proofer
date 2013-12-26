require "spec_helper"

describe "Image tests" do
  it "passes for existing external images" do
    externalImageFilepath = "#{FIXTURES_DIR}/existingImageExternal.html"
    output = capture_stderr { HTML::Proofer.new(externalImageFilepath).run }
    output.should == ""
  end

  it "fails for image without alt attribute" do
    missingAltFilepath = "#{FIXTURES_DIR}/missingImageAlt.html"
    output = capture_stderr { HTML::Proofer.new(missingAltFilepath).run }
    output.should match /gpl.png does not have an alt attribute/
  end

  it "fails for image with an empty alt attribute" do
    missingAltFilepath = "#{FIXTURES_DIR}/missingImageAltText.html"
    output = capture_stderr { HTML::Proofer.new(missingAltFilepath).run }
    output.should match /gpl.png does not have an alt attribute/
  end

  it "fails for missing external images" do
    externalImageFilepath = "#{FIXTURES_DIR}/missingImageExternal.html"
    output = capture_stderr { HTML::Proofer.new(externalImageFilepath).run }
    output.should match /External link http:\/\/www.whatthehell failed: could not resolve host/
  end

  it "fails for missing internal images" do
    internalImageFilepath = "#{FIXTURES_DIR}/missingImageInternal.html"
    output = capture_stderr { HTML::Proofer.new(internalImageFilepath).run }
    output.should match /doesnotexist.png does not exist/
  end

  it "fails for image with no src" do
    imageSrcFilepath = "#{FIXTURES_DIR}/missingImageSrc.html"
    output = capture_stderr { HTML::Proofer.new(imageSrcFilepath).run }
    output.should match /image has no src attribute/
  end

  it "fails for image with default mac filename" do
    terribleImageName = "#{FIXTURES_DIR}/terribleImageName.html"
    output = capture_stderr { HTML::Proofer.new(terribleImageName).run }
    output.should match /image has a terrible filename/
  end

  it 'ignores images marked as ignore data-proofer-ignore' do
    ignorableImages = "#{FIXTURES_DIR}/ignorableImages.html"
    output = capture_stderr { HTML::Proofer.new(ignorableImages).run }
    output.should == ""
  end

  it 'properly checks relative links' do
    relativeLinks = "#{FIXTURES_DIR}/brokenRelativeImages.html"
    output = capture_stderr { HTML::Proofer.new(relativeLinks).run }
    output.should == ""

    relativeLinks = "#{FIXTURES_DIR}/resources/books/nestedRelativeImages.html"
    output = capture_stderr { HTML::Proofer.new(relativeLinks).run }
    output.should == ""
  end
end
