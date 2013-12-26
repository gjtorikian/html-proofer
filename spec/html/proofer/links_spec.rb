require "spec_helper"

describe "Links tests" do

  it "fails for broken external hash (even if the file exists)" do
    brokenHashExternalFilepath = "#{FIXTURES_DIR}/brokenHashExternal.html"
    output = capture_stderr { HTML::Proofer.new(brokenHashExternalFilepath).run }
    output.should match /linking to .\/missingImageAlt.html#asdfasfdkafl, but asdfasfdkafl does not exist/
  end

  it "fails for broken internal hash" do
    brokenHashInternalFilepath = "#{FIXTURES_DIR}/brokenHashInternal.html"
    output = capture_stderr { HTML::Proofer.new(brokenHashInternalFilepath).run }
    output.should match /linking to internal hash #noHash that does not exist/
  end

  it "fails for broken external links" do
    brokenLinkExternalFilepath = "#{FIXTURES_DIR}/brokenLinkExternal.html"
    output = capture_stderr { HTML::Proofer.new(brokenLinkExternalFilepath).run }
    output.should match /External link http:\/\/www.asdo3IRJ395295jsingrkrg4.com failed/
  end

  it "fails for broken internal links" do
    brokenLinkInternalFilepath = "#{FIXTURES_DIR}/brokenLinkInternal.html"
    output = capture_stderr { HTML::Proofer.new(brokenLinkInternalFilepath).run }
    output.should match /internally linking to .\/notreal.html, which does not exist/
  end

  it "fails for link with no href" do
    missingLinkHrefFilepath = "#{FIXTURES_DIR}/missingLinkHref.html"
    output = capture_stderr { HTML::Proofer.new(missingLinkHrefFilepath).run }
    output.should match /link has no href attribute/
  end

  it "should follow redirects" do
    linkWithRedirectFilepath = "#{FIXTURES_DIR}/linkWithRedirect.html"
    output = capture_stderr { HTML::Proofer.new(linkWithRedirectFilepath).run }
    output.should == ""
  end

  it "should understand https" do
    linkWithHttpsFilepath = "#{FIXTURES_DIR}/linkWithHttps.html"
    output = capture_stderr { HTML::Proofer.new(linkWithHttpsFilepath).run }
    output.should == ""
  end

  it "fails for broken hash links with status code numbers" do
    brokenLinkWithNumberFilepath = "#{FIXTURES_DIR}/brokenLinkWithNumber.html"
    output = capture_stderr { HTML::Proofer.new(brokenLinkWithNumberFilepath).run }
    output.should match /linking to internal hash #25-method-not-allowed that does not exist/
  end

  it 'properly resolves implicit /index.html in link paths' do
    linkToFolder = "#{FIXTURES_DIR}/linkToFolder.html"
    output = capture_stderr { HTML::Proofer.new(linkToFolder).run }
    output.should == ""
  end

  it 'properly checks links to root' do
    rootLink = "#{FIXTURES_DIR}/rootLink.html"
    output = capture_stderr { HTML::Proofer.new(rootLink).run }
    output.should == ""
  end

  it 'properly checks relative links' do
    relativeLinks = "#{FIXTURES_DIR}/relativeLinks.html"
    output = capture_stderr { HTML::Proofer.new(relativeLinks).run }
    output.should == ""
  end

  it 'ignores links marked as ignore data-proofer-ignore' do
    ignorableLinks = "#{FIXTURES_DIR}/ignorableLinks.html"
    output = capture_stderr { HTML::Proofer.new(ignorableLinks).run }
    output.should == ""
  end

  it 'translates links via href_swap' do
    translatedLink = "#{FIXTURES_DIR}/linkTranslatedViaHrefSwap.html"
    output = capture_stderr { HTML::Proofer.new(translatedLink, {:href_swap => { /\A\/articles\/([\w-]+)/ => "\\1.html" }}).run }
    output.should == ""
  end
end
