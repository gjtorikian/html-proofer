require "spec_helper"

describe "Images test" do
  it "passes for existing external images" do
    externalImageFilepath = "#{FIXTURES_DIR}/images/existingImageExternal.html"
    proofer = make_proofer(externalImageFilepath)
    proofer.failed_tests.should == []
  end

  it "fails for image without alt attribute" do
    missingAltFilepath = "#{FIXTURES_DIR}/images/missingImageAlt.html"
    proofer = make_proofer(missingAltFilepath)
    proofer.failed_tests.first.should match /gpl.png does not have an alt attribute/
  end

  it "fails for image with an empty alt attribute" do
    missingAltFilepath = "#{FIXTURES_DIR}/images/missingImageAltText.html"
    proofer = make_proofer(missingAltFilepath)
    proofer.failed_tests.first.should match /gpl.png does not have an alt attribute/
  end

  it "fails for missing external images" do
    externalImageFilepath = "#{FIXTURES_DIR}/images/missingImageExternal.html"
    proofer = make_proofer(externalImageFilepath)
    proofer.failed_tests.first.should match /External link http:\/\/www.whatthehell\/? failed: 0 Couldn't resolve host/
  end

  it "fails for missing internal images" do
    internalImageFilepath = "#{FIXTURES_DIR}/images/missingImageInternal.html"
    proofer = make_proofer(internalImageFilepath)
    proofer.failed_tests.first.should match /doesnotexist.png does not exist/
  end

  it "fails for image with no src" do
    imageSrcFilepath = "#{FIXTURES_DIR}/images/missingImageSrc.html"
    proofer = make_proofer(imageSrcFilepath)
    proofer.failed_tests.first.should match /image has no src attribute/
  end

  it "fails for image with default mac filename" do
    terribleImageName = "#{FIXTURES_DIR}/images/terribleImageName.html"
    proofer = make_proofer(terribleImageName)
    proofer.failed_tests.first.should match /image has a terrible filename/
  end

  it 'ignores images marked as ignore data-proofer-ignore' do
    ignorableImages = "#{FIXTURES_DIR}/images/ignorableImages.html"
    proofer = make_proofer(ignorableImages)
    proofer.failed_tests.should == []
  end

  it 'properly checks relative images' do
    relativeImages = "#{FIXTURES_DIR}/images/rootRelativeImages.html"
    proofer = make_proofer(relativeImages)
    proofer.failed_tests.should == []

    relativeImages = "#{FIXTURES_DIR}/resources/books/nestedRelativeImages.html"
    proofer = make_proofer(relativeImages)
    proofer.failed_tests.should == []
  end

  it 'properly ignores data URI images' do
    dataURIImage = "#{FIXTURES_DIR}/images/workingDataURIImage.html"
    proofer = make_proofer(dataURIImage)
    proofer.failed_tests.should == []
  end

  it "works for valid images missing the protocol" do
    missingProtocolLink = "#{FIXTURES_DIR}/images/image_missing_protocol_valid.html"
    proofer = make_proofer(missingProtocolLink)
    proofer.failed_tests.should == []
  end

  it "fails for invalid images missing the protocol" do
    missingProtocolLink = "#{FIXTURES_DIR}/images/image_missing_protocol_invalid.html"
    proofer = make_proofer(missingProtocolLink)
    proofer.failed_tests.first.should match /404 No error/
  end

  it 'properly checks relative links' do
    relativeLinks = "#{FIXTURES_DIR}/images/relativeToSelf.html"
    proofer = make_proofer(relativeLinks)
    proofer.failed_tests.should == []
  end

  it 'properly ignores missing alt tags when asked' do
    ignorableLinks = "#{FIXTURES_DIR}/images/ignorableAltViaOptions.html"
    proofer = make_proofer(ignorableLinks, {:alt_ignore => [/wikimedia/, "gpl.png"]})
    proofer.failed_tests.should == []
  end

  it 'properly ignores missing alt tags, but not all URLs, when asked' do
    ignorableLinks = "#{FIXTURES_DIR}/images/ignoreAltButNotLink.html"
    proofer = make_proofer(ignorableLinks, {:alt_ignore => [/.*/]})
    proofer.failed_tests.first.should match /Couldn't resolve host name/
    proofer.failed_tests.first.should_not match /does not have an alt attribute/
  end
end
