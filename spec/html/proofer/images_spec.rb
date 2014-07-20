require "spec_helper"

describe "Images test" do
  it "passes for existing external images" do
    externalImageFilepath = "#{FIXTURES_DIR}/images/existingImageExternal.html"
    output = capture_stderr { HTML::Proofer.new(externalImageFilepath).run }
    output.should == ""
  end

  it "fails for image without alt attribute" do
    missingAltFilepath = "#{FIXTURES_DIR}/images/missingImageAlt.html"
    output = capture_stderr { HTML::Proofer.new(missingAltFilepath).run }
    output.should match /gpl.png does not have an alt attribute/
  end

  it "fails for image with an empty alt attribute" do
    missingAltFilepath = "#{FIXTURES_DIR}/images/missingImageAltText.html"
    output = capture_stderr { HTML::Proofer.new(missingAltFilepath).run }
    output.should match /gpl.png does not have an alt attribute/
  end

  it "fails for missing external images" do
    externalImageFilepath = "#{FIXTURES_DIR}/images/missingImageExternal.html"
    output = capture_stderr { HTML::Proofer.new(externalImageFilepath).run }
    output.should match /External link http:\/\/www.whatthehell\/? failed: 0 Couldn't resolve host/
  end

  it "fails for missing internal images" do
    internalImageFilepath = "#{FIXTURES_DIR}/images/missingImageInternal.html"
    output = capture_stderr { HTML::Proofer.new(internalImageFilepath).run }
    output.should match /doesnotexist.png does not exist/
  end

  it "fails for image with no src" do
    imageSrcFilepath = "#{FIXTURES_DIR}/images/missingImageSrc.html"
    output = capture_stderr { HTML::Proofer.new(imageSrcFilepath).run }
    output.should match /image has no src attribute/
  end

  it "fails for image with default mac filename" do
    terribleImageName = "#{FIXTURES_DIR}/images/terribleImageName.html"
    output = capture_stderr { HTML::Proofer.new(terribleImageName).run }
    output.should match /image has a terrible filename/
  end

  it 'ignores images marked as ignore data-proofer-ignore' do
    ignorableImages = "#{FIXTURES_DIR}/images/ignorableImages.html"
    output = capture_stderr { HTML::Proofer.new(ignorableImages).run }
    output.should == ""
  end

  it 'properly checks relative images' do
    relativeImages = "#{FIXTURES_DIR}/images/rootRelativeImages.html"
    output = capture_stderr { HTML::Proofer.new(relativeImages).run }
    output.should == ""

    relativeImages = "#{FIXTURES_DIR}/resources/books/nestedRelativeImages.html"
    output = capture_stderr { HTML::Proofer.new(relativeImages).run }
    output.should == ""
  end

  it 'properly ignores data URI images' do
    dataURIImage = "#{FIXTURES_DIR}/images/workingDataURIImage.html"
    output = capture_stderr { HTML::Proofer.new(dataURIImage).run }
    output.should == ""
  end

  it "works for valid images missing the protocol" do
    missingProtocolLink = "#{FIXTURES_DIR}/images/image_missing_protocol_valid.html"
    output = capture_stderr { HTML::Proofer.new(missingProtocolLink).run }
    output.should == ""
  end

  it "fails for invalid images missing the protocol" do
    missingProtocolLink = "#{FIXTURES_DIR}/images/image_missing_protocol_invalid.html"
    output = capture_stderr { HTML::Proofer.new(missingProtocolLink).run }
    output.should match /404 No error/
  end

  it 'properly checks relative links' do
    relativeLinks = "#{FIXTURES_DIR}/images/relativeToSelf.html"
    output = capture_stderr { HTML::Proofer.new(relativeLinks).run }
    output.should == ""
  end
end
