require "spec_helper"

describe "Links test" do

  it "fails for broken external hash (even if the file exists)" do
    brokenHashExternalFilepath = "#{FIXTURES_DIR}/links/brokenHashExternal.html"
    output = capture_stderr { HTML::Proofer.new(brokenHashExternalFilepath).run }
    output.should match /linking to ..\/images\/missingImageAlt.html#asdfasfdkafl, but asdfasfdkafl does not exist/
  end

  it "fails for broken hashes on the web (even if the file exists)" do
    brokenHashOnTheWeb = "#{FIXTURES_DIR}/links/brokenHashOnTheWeb.html"
    output = capture_stderr { HTML::Proofer.new(brokenHashOnTheWeb).run }
    output.should match /but the hash 'no' does not/
  end

  it "passes for GitHub hashes on the web" do
    githubHash = "#{FIXTURES_DIR}/links/githubHash.html"
    output = capture_stderr { HTML::Proofer.new(githubHash).run }
    output.should == ""
  end

  it "passes for broken hashes on the web (when we look only for 4xx)" do
    options = { :only_4xx => true }
    brokenHashOnTheWeb = "#{FIXTURES_DIR}/links/brokenHashOnTheWeb.html"
    output = capture_stderr { HTML::Proofer.new(brokenHashOnTheWeb, options).run }
    output.should == ""
  end

  it "fails for broken internal hash" do
    brokenHashInternalFilepath = "#{FIXTURES_DIR}/links/brokenHashInternal.html"
    output = capture_stderr { HTML::Proofer.new(brokenHashInternalFilepath).run }
    output.should match /linking to internal hash #noHash that does not exist/
  end

  it "fails for broken external links" do
    brokenLinkExternalFilepath = "#{FIXTURES_DIR}/links/brokenLinkExternal.html"
    output = capture_stderr { HTML::Proofer.new(brokenLinkExternalFilepath).run }
    output.should match /External link http:\/\/www.asdo3IRJ395295jsingrkrg4.com\/? failed: 0 Couldn't resolve host name/
  end

  it "fails for broken internal links" do
    brokenLinkInternalFilepath = "#{FIXTURES_DIR}/links/brokenLinkInternal.html"
    output = capture_stderr { HTML::Proofer.new(brokenLinkInternalFilepath).run }
    output.should match /internally linking to .\/notreal.html, which does not exist/
  end

  it "fails for link with no href" do
    missingLinkHrefFilepath = "#{FIXTURES_DIR}/links/missingLinkHref.html"
    output = capture_stderr { HTML::Proofer.new(missingLinkHrefFilepath).run }
    output.should match /anchor has no href attribute/
  end

  it "should follow redirects" do
    linkWithRedirectFilepath = "#{FIXTURES_DIR}/links/linkWithRedirect.html"
    output = capture_stderr { HTML::Proofer.new(linkWithRedirectFilepath).run }
    output.should == ""
  end

  it "fails on redirects if not following" do
    options = { :followlocation => false }
    linkWithRedirectFilepath = "#{FIXTURES_DIR}/links/linkWithRedirect.html"
    output = capture_stderr { HTML::Proofer.new(linkWithRedirectFilepath, options).run }
    output.should match /External link https:\/\/help.github.com\/changing-author-info\/ failed: 301 No error/
  end

  it "does not fail on redirects we're not following" do
    # this test should emit a 301--see above--but we're intentionally supressing it
    options = { :only_4xx => true, :followlocation => false }
    linkWithRedirectFilepath = "#{FIXTURES_DIR}/links/linkWithRedirect.html"
    output = capture_stderr { HTML::Proofer.new(linkWithRedirectFilepath, options).run }
    output.should == ""
  end

  it "should understand https" do
    linkWithHttpsFilepath = "#{FIXTURES_DIR}/links/linkWithHttps.html"
    output = capture_stderr { HTML::Proofer.new(linkWithHttpsFilepath).run }
    output.should == ""
  end

  it "fails for broken hash links with status code numbers" do
    brokenLinkWithNumberFilepath = "#{FIXTURES_DIR}/links/brokenLinkWithNumber.html"
    output = capture_stderr { HTML::Proofer.new(brokenLinkWithNumberFilepath).run }
    output.should match /linking to internal hash #25-method-not-allowed that does not exist/
  end

  it 'properly resolves implicit /index.html in link paths' do
    linkToFolder = "#{FIXTURES_DIR}/links/linkToFolder.html"
    output = capture_stderr { HTML::Proofer.new(linkToFolder).run }
    output.should == ""
  end

  it 'properly checks links to root' do
    rootLink = "#{FIXTURES_DIR}/links/rootLink.html"
    output = capture_stderr { HTML::Proofer.new(rootLink).run }
    output.should == ""
  end

  it 'properly checks relative links' do
    relativeLinks = "#{FIXTURES_DIR}/links/relativeLinks.html"
    output = capture_stderr { HTML::Proofer.new(relativeLinks).run }
    output.should == ""
  end

  it 'properly checks ssl links' do
    checkSSLLinks = "#{FIXTURES_DIR}/links/checkSSLLinks.html"
    output = capture_stderr { HTML::Proofer.new(checkSSLLinks).run }
    output.should == ""
  end

  it 'ignores links marked as ignore data-proofer-ignore' do
    ignorableLinks = "#{FIXTURES_DIR}/links/ignorableLinks.html"
    output = capture_stderr { HTML::Proofer.new(ignorableLinks).run }
    output.should == ""
  end

  it 'ignores links via href_ignore' do
    ignorableLinks = "#{FIXTURES_DIR}/links/ignorableLinksViaOptions.html"
    output = capture_stderr { HTML::Proofer.new(ignorableLinks, {:href_ignore => [/^http:\/\//, /sdadsad/, "../whaadadt.html"]}).run }
    output.should == ""
  end

  it 'translates links via href_swap' do
    translatedLink = "#{FIXTURES_DIR}/links/linkTranslatedViaHrefSwap.html"
    output = capture_stderr { HTML::Proofer.new(translatedLink, {:href_swap => { /\A\/articles\/([\w-]+)/ => "\\1.html" }}).run }
    output.should == ""
  end

  it 'finds a mix of broken and unbroken links' do
    multipleProblems = "#{FIXTURES_DIR}/links/multipleProblems.html"
    output = capture_stderr { HTML::Proofer.new(multipleProblems).run }
    output.should match /linking to internal hash #anadaasdadsadschor that does not exist/
  end

  it 'ignores valid mailto links' do
    ignorableLinks = "#{FIXTURES_DIR}/links/mailto_link.html"
    output = capture_stderr { HTML::Proofer.new(ignorableLinks).run }
    output.should == ""
  end

  it "fails for blank mailto links" do
    blankMailToLink = "#{FIXTURES_DIR}/links/blank_mailto_link.html"
    output = capture_stderr { HTML::Proofer.new(blankMailToLink).run }
    output.should match /mailto: is an invalid URL/
  end

  it 'ignores valid tel links' do
    ignorableLinks = "#{FIXTURES_DIR}/links/tel_link.html"
    output = capture_stderr { HTML::Proofer.new(ignorableLinks).run }
    output.should == ""
  end

  it "fails for blank tel links" do
    blankTelLink = "#{FIXTURES_DIR}/links/blank_tel_link.html"
    output = capture_stderr { HTML::Proofer.new(blankTelLink).run }
    output.should match /tel: is an invalid URL/
  end

  it 'ignores javascript links' do
    javascriptLink = "#{FIXTURES_DIR}/links/javascript_link.html"
    output = capture_stderr { HTML::Proofer.new(javascriptLink).run }
    output.should == ""
  end

  it "works for valid links missing the protocol" do
    missingProtocolLink = "#{FIXTURES_DIR}/links/link_missing_protocol_valid.html"
    output = capture_stderr { HTML::Proofer.new(missingProtocolLink).run }
    output.should == ""
  end

  it "fails for invalid links missing the protocol" do
    missingProtocolLink = "#{FIXTURES_DIR}/links/link_missing_protocol_invalid.html"
    output = capture_stderr { HTML::Proofer.new(missingProtocolLink).run }
    output.should match /Couldn't resolve host name/
  end

  it "works for valid href within link elements" do
    head_link = "#{FIXTURES_DIR}/links/head_link_href.html"
    output = capture_stderr { HTML::Proofer.new(head_link).run }
    output.should == ""
  end

  it "fails for empty href within link elements" do
    head_link = "#{FIXTURES_DIR}/links/head_link_href_empty.html"
    output = capture_stderr { HTML::Proofer.new(head_link).run }
    output.should match /anchor has no href attribute/
  end

  it "fails for absent href within link elements" do
    head_link = "#{FIXTURES_DIR}/links/head_link_href_absent.html"
    output = capture_stderr { HTML::Proofer.new(head_link).run }
    output.should match /anchor has no href attribute/
  end

  it "fails for internal linking to a directory without trailing slash" do
    options = { :followlocation => false }
    internal = "#{FIXTURES_DIR}/links/link_directory_without_slash.html"
    output = capture_stderr { HTML::Proofer.new(internal, options).run }
    output.should match /without trailing slash/
  end

  it "works for array of links" do
    output = capture_stderr { HTML::Proofer.new(["www.github.com", "foofoofoo.biz"]).run }
    output.should match /foofoofoo.biz\/? failed: 0 Couldn't resolve host name/
  end

  it "works for broken anchors within pre" do
    anchor_pre = "#{FIXTURES_DIR}/links/anchors_in_pre.html"
    output = capture_stderr { HTML::Proofer.new(anchor_pre).run }
    output.should == ""
  end

  it "works for broken link within pre" do
    link_pre = "#{FIXTURES_DIR}/links/links_in_pre.html"
    output = capture_stderr { HTML::Proofer.new(link_pre).run }
    output.should == ""
  end

  it "works for pipes in the URL" do
    escape_pipes = "#{FIXTURES_DIR}/links/escape_pipes.html"
    output = capture_stderr { HTML::Proofer.new(escape_pipes).run }
    output.should == ""
  end

  it "fails for broken hash with query" do
    broken_hash = "#{FIXTURES_DIR}/links/broken_hash_with_query.html"
    output = capture_stderr { HTML::Proofer.new(broken_hash).run }
    output.should match /linking to internal hash #example that does not exist/
  end

  it "works for directory index file" do
    options = { :directory_index => "index.php" }
    link_pointing_to_directory = "#{FIXTURES_DIR}/links/link_pointing_to_directory.html"
    output = capture_stderr { HTML::Proofer.new(link_pointing_to_directory, options).run }
    output.should == ""
  end

  it "ensures Typhoeus options are passed" do
    options = { ssl_verifypeer: false }
    typhoeus_options_link = "#{FIXTURES_DIR}/links/ensure_typhoeus_options.html"
    output = capture_stderr { HTML::Proofer.new(typhoeus_options_link, options).run }
    output.should == ""
  end
end
