require 'spec_helper'

describe 'Images test' do
  it 'passes for existing external images' do
    externalImageFilepath = "#{FIXTURES_DIR}/images/existingImageExternal.html"
    proofer = run_proofer(externalImageFilepath)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for image without alt attribute' do
    missingAltFilepath = "#{FIXTURES_DIR}/images/missingImageAlt.html"
    proofer = run_proofer(missingAltFilepath)
    expect(proofer.failed_tests.first).to match(/gpl.png does not have an alt attribute/)
  end

  it 'fails for image with an empty alt attribute' do
    missingAltFilepath = "#{FIXTURES_DIR}/images/missingImageAltText.html"
    proofer = run_proofer(missingAltFilepath)
    expect(proofer.failed_tests.first).to match(/gpl.png does not have an alt attribute/)
  end

  it 'fails for image with nothing but spaces in alt attribute' do
    emptyAltFilepath = "#{FIXTURES_DIR}/images/emptyImageAltText.html"
    proofer = run_proofer(emptyAltFilepath)
    expect(proofer.failed_tests.first).to match(/gpl.png does not have an alt attribute/)
    expect(proofer.failed_tests.length).to equal(3)
  end

  it 'passes when ignoring image with nothing but spaces in alt attribute' do
    emptyAltFilepath = "#{FIXTURES_DIR}/images/emptyImageAltText.html"
    proofer = run_proofer(emptyAltFilepath, {:alt_ignore => [/.+/]})
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for missing external images' do
    externalImageFilepath = "#{FIXTURES_DIR}/images/missingImageExternal.html"
    proofer = run_proofer(externalImageFilepath)
    expect(proofer.failed_tests.first).to match(/failed: response code 0/)
  end

  it 'fails for missing internal images' do
    internalImageFilepath = "#{FIXTURES_DIR}/images/missingImageInternal.html"
    proofer = run_proofer(internalImageFilepath)
    expect(proofer.failed_tests.first).to match(/doesnotexist.png does not exist/)
  end

  it 'fails for image with no src' do
    imageSrcFilepath = "#{FIXTURES_DIR}/images/missingImageSrc.html"
    proofer = run_proofer(imageSrcFilepath)
    expect(proofer.failed_tests.first).to match(/image has no src or srcset attribute/)
  end

  it 'fails for image with default mac filename' do
    terribleImageName = "#{FIXTURES_DIR}/images/terribleImageName.html"
    proofer = run_proofer(terribleImageName)
    expect(proofer.failed_tests.first).to match(/image has a terrible filename/)
  end

  it 'ignores images marked as ignore data-proofer-ignore' do
    ignorableImages = "#{FIXTURES_DIR}/images/ignorableImages.html"
    proofer = run_proofer(ignorableImages)
    expect(proofer.failed_tests).to eq []
  end

  it 'ignores images via url_ignore' do
    ignorableImage = "#{FIXTURES_DIR}/images/terribleImageName.html"
    proofer = run_proofer(ignorableImage, { :url_ignore => [%r{./Screen.+}] })
    expect(proofer.failed_tests).to eq []
  end

  it 'translates images via url_swap' do
    translatedLink = "#{FIXTURES_DIR}/images/terribleImageName.html"
    proofer = run_proofer(translatedLink, { :url_swap => { %r{./Screen.+} => 'gpl.png' } })
    expect(proofer.failed_tests).to eq []
  end

  it 'properly checks relative images' do
    relativeImages = "#{FIXTURES_DIR}/images/rootRelativeImages.html"
    proofer = run_proofer(relativeImages)
    expect(proofer.failed_tests).to eq []

    relativeImages = "#{FIXTURES_DIR}/resources/books/nestedRelativeImages.html"
    proofer = run_proofer(relativeImages)
    expect(proofer.failed_tests).to eq []
  end

  it 'properly ignores data URI images' do
    dataURIImage = "#{FIXTURES_DIR}/images/workingDataURIImage.html"
    proofer = run_proofer(dataURIImage)
    expect(proofer.failed_tests).to eq []
  end

  it 'works for valid images missing the protocol' do
    missingProtocolLink = "#{FIXTURES_DIR}/images/image_missing_protocol_valid.html"
    proofer = run_proofer(missingProtocolLink)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for invalid images missing the protocol' do
    missingProtocolLink = "#{FIXTURES_DIR}/images/image_missing_protocol_invalid.html"
    proofer = run_proofer(missingProtocolLink)
    expect(proofer.failed_tests.first).to match(/failed: 404/)
  end

  it 'properly checks relative links' do
    relativeLinks = "#{FIXTURES_DIR}/images/relativeToSelf.html"
    proofer = run_proofer(relativeLinks)
    expect(proofer.failed_tests).to eq []
  end

  it 'properly ignores missing alt tags when asked' do
    ignorableLinks = "#{FIXTURES_DIR}/images/ignorableAltViaOptions.html"
    proofer = run_proofer(ignorableLinks, {:alt_ignore => [/wikimedia/, "gpl.png"]})
    expect(proofer.failed_tests).to eq []
  end

  it 'properly ignores missing alt tags, but not all URLs, when asked' do
    ignorableLinks = "#{FIXTURES_DIR}/images/ignoreAltButNotLink.html"
    proofer = run_proofer(ignorableLinks, {:alt_ignore => [/.*/]})
    expect(proofer.failed_tests.first).to match(/failed: response code 0/)
    expect(proofer.failed_tests.first).to_not match /does not have an alt attribute/
  end

  it 'properly ignores empty alt attribute when empty_alt_ignore set' do
    missingAltFilepath = "#{FIXTURES_DIR}/images/emptyImageAltText.html"
    proofer = run_proofer(missingAltFilepath, {:empty_alt_ignore => true})
    expect(proofer.failed_tests).to eq []
  end

  it 'properly ignores empty alt attributes, but not missing alt attributes, when empty_alt_ignore set' do
    missingAltFilepath = "#{FIXTURES_DIR}/images/missingImageAlt.html"
    proofer = run_proofer(missingAltFilepath, {:empty_alt_ignore => true})
    expect(proofer.failed_tests.first).to match(/gpl.png does not have an alt attribute/)
  end

  it 'works for images with a srcset' do
    srcSetCheck = "#{FIXTURES_DIR}/images/srcSetCheck.html"
    proofer = run_proofer(srcSetCheck)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for images with a srcset but missing alt' do
    srcSetMissingAlt = "#{FIXTURES_DIR}/images/srcSetMissingAlt.html"
    proofer = run_proofer(srcSetMissingAlt)
    expect(proofer.failed_tests.first).to match(/image gpl.png does not have an alt attribute/)
  end

  it 'fails for images with an alt but missing src or srcset' do
    srcSetMissingAlt = "#{FIXTURES_DIR}/images/srcSetMissingImage.html"
    proofer = run_proofer(srcSetMissingAlt)
    expect(proofer.failed_tests.first).to match(/internal image notreal.png does not exist/)
  end

  it 'properly ignores missing alt tags when asked for srcset' do
    ignorableLinks = "#{FIXTURES_DIR}/images/srcSetIgnorable.html"
    proofer = run_proofer(ignorableLinks, {:alt_ignore => [/wikimedia/, "gpl.png"]})
    expect(proofer.failed_tests).to eq []
  end
end
