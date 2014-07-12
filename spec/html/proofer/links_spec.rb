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
    output.should match /External link http:\/\/www.asdo3IRJ395295jsingrkrg4.com\/? failed: 0 Couldn't resolve host name/
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

  it "fails on redirects if not following" do
    options = { :followlocation => false }
    linkWithRedirectFilepath = "#{FIXTURES_DIR}/linkWithRedirect.html"
    output = capture_stderr { HTML::Proofer.new(linkWithRedirectFilepath, options).run }
    output.should_not == ""
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

  it 'properly checks ssl links' do
    checkSSLLinks = "#{FIXTURES_DIR}/checkSSLLinks.html"
    output = capture_stderr { HTML::Proofer.new(checkSSLLinks).run }
    output.should == ""
  end

  it 'ignores links marked as ignore data-proofer-ignore' do
    ignorableLinks = "#{FIXTURES_DIR}/ignorableLinks.html"
    output = capture_stderr { HTML::Proofer.new(ignorableLinks).run }
    output.should == ""
  end

  it 'ignores links via href_ignore' do
    ignorableLinks = "#{FIXTURES_DIR}/ignorableLinksViaOptions.html"
    output = capture_stderr { HTML::Proofer.new(ignorableLinks, {:href_ignore => [/^http:\/\//, /sdadsad/, "../whaadadt.html"]}).run }
    output.should == ""
  end

  it 'translates links via href_swap' do
    translatedLink = "#{FIXTURES_DIR}/linkTranslatedViaHrefSwap.html"
    output = capture_stderr { HTML::Proofer.new(translatedLink, {:href_swap => { /\A\/articles\/([\w-]+)/ => "\\1.html" }}).run }
    output.should == ""
  end

  it 'finds a mix of broken and unbroken links' do
    multipleProblems = "#{FIXTURES_DIR}/multipleProblems.html"
    output = capture_stderr { HTML::Proofer.new(multipleProblems).run }
    output.should match /linking to internal hash #anadaasdadsadschor that does not exist/
  end

  it 'ignores valid mailto links' do
    ignorableLinks = "#{FIXTURES_DIR}/mailto_link.html"
    output = capture_stderr { HTML::Proofer.new(ignorableLinks).run }
    output.should == ""
  end

  it "fails for blank mailto links" do
    blankMailToLink = "#{FIXTURES_DIR}/blank_mailto_link.html"
    output = capture_stderr { HTML::Proofer.new(blankMailToLink).run }
    output.should match /mailto: is an invalid URL/
  end

  it 'ignores valid tel links' do
    ignorableLinks = "#{FIXTURES_DIR}/tel_link.html"
    output = capture_stderr { HTML::Proofer.new(ignorableLinks).run }
    output.should == ""
  end

  it "fails for blank tel links" do
    blankTelLink = "#{FIXTURES_DIR}/blank_tel_link.html"
    output = capture_stderr { HTML::Proofer.new(blankTelLink).run }
    output.should match /tel: is an invalid URL/
  end

  it "works for valid links missing the protocol" do
    missingProtocolLink = "#{FIXTURES_DIR}/link_missing_protocol_valid.html"
    output = capture_stderr { HTML::Proofer.new(missingProtocolLink).run }
    output.should == ""
  end

  it "fails for invalid links missing the protocol" do
    missingProtocolLink = "#{FIXTURES_DIR}/link_missing_protocol_invalid.html"
    output = capture_stderr { HTML::Proofer.new(missingProtocolLink).run }
    output.should match /Couldn't resolve host name/
  end

  it "works for valid href within link elements" do
    head_link = "#{FIXTURES_DIR}/head_link_href.html"
    output = capture_stderr { HTML::Proofer.new(head_link).run }
    output.should == ""
  end

  it "fails for empty href within link elements" do
    head_link = "#{FIXTURES_DIR}/head_link_href_empty.html"
    output = capture_stderr { HTML::Proofer.new(head_link).run }
    output.should match /link has no href attribute/
  end

  it "fails for absent href within link elements" do
    head_link = "#{FIXTURES_DIR}/head_link_href_absent.html"
    output = capture_stderr { HTML::Proofer.new(head_link).run }
    output.should match /link has no href attribute/
  end

  it "fails for internal linking to a directory without trailing slash" do
    options = { :followlocation => false }
    internal = "#{FIXTURES_DIR}/link_directory_without_slash.html"
    output = capture_stderr { HTML::Proofer.new(internal, options).run }
    output.should match /without trailing slash/
  end
end
