require "spec_helper"

describe "Links tests" do

  it "fails for broken external hash (even if the file exists)" do
    brokenHashExternalFilepath = "#{FIXTURES_DIR}/brokenHashExternal.html"
    @linkCheck = Links.new("#{FIXTURES_DIR}", brokenHashExternalFilepath, HTML::Proofer.create_nokogiri(brokenHashExternalFilepath))
    @linkCheck.run
    @linkCheck.issues[1].should eq("spec/html/proofer/fixtures/brokenHashExternal.html".blue + ": linking to ./missingImageAlt.html#asdfasfdkafl, but asdfasfdkafl does not exist")
  end

  it "fails for broken internal hash" do
    brokenHashInternalFilepath = "#{FIXTURES_DIR}/brokenHashInternal.html"
    @linkCheck = Links.new("#{FIXTURES_DIR}", brokenHashInternalFilepath, HTML::Proofer.create_nokogiri(brokenHashInternalFilepath))
    @linkCheck.run
    @linkCheck.issues[0].should eq("spec/html/proofer/fixtures/brokenHashInternal.html".blue + ": linking to internal hash #noHash that does not exist")
  end

  it "fails for broken external links" do
    brokenLinkExternalFilepath = "#{FIXTURES_DIR}/brokenLinkExternal.html"
    @linkCheck = Links.new("#{FIXTURES_DIR}", brokenLinkExternalFilepath, HTML::Proofer.create_nokogiri(brokenLinkExternalFilepath))
    @linkCheck.run
    @linkCheck.hydra.run
    @linkCheck.issues[0].sub!(/ #<Typhoeus::Response:[\w]+>/, "")
    @linkCheck.issues[0].should eq("spec/html/proofer/fixtures/brokenLinkExternal.html".blue + ": externally linking to http://www.asdo3IRJ395295jsingrkrg4.com, which does not exist. Couldn't resolve host name!")
  end

  it "fails for broken internal links" do
    brokenLinkInternalFilepath = "#{FIXTURES_DIR}/brokenLinkInternal.html"
    @linkCheck = Links.new("#{FIXTURES_DIR}", brokenLinkInternalFilepath, HTML::Proofer.create_nokogiri(brokenLinkInternalFilepath))
    @linkCheck.run
    @linkCheck.issues[0].should eq("spec/html/proofer/fixtures/brokenLinkInternal.html".blue + ": internally linking to ./notreal.html, which does not exist")
  end

  it "fails for link with no href" do
    missingLinkHrefFilepath = "#{FIXTURES_DIR}/missingLinkHref.html"
    @linkCheck = Links.new("#{FIXTURES_DIR}", missingLinkHrefFilepath, HTML::Proofer.create_nokogiri(missingLinkHrefFilepath))
    @linkCheck.run
    @linkCheck.issues[0].should eq("spec/html/proofer/fixtures/missingLinkHref.html".blue + ": link has no href attribute")
  end

  it "should follow redirects" do
    linkWithRedirectFilepath = "#{FIXTURES_DIR}/linkWithRedirect.html"
    @linkCheck = Links.new("#{FIXTURES_DIR}", linkWithRedirectFilepath, HTML::Proofer.create_nokogiri(linkWithRedirectFilepath))
    @linkCheck.run
    @linkCheck.issues[0].should eq(nil)
  end

  it "should understand https" do
    linkWithHttpsFilepath = "#{FIXTURES_DIR}/linkWithHttps.html"
    @linkCheck = Links.new("#{FIXTURES_DIR}", linkWithHttpsFilepath, HTML::Proofer.create_nokogiri(linkWithHttpsFilepath))
    @linkCheck.run
    @linkCheck.issues[0].should eq(nil)
  end

  it "fails for broken hash links with status code numbers" do
    brokenLinkWithNumberFilepath = "#{FIXTURES_DIR}/brokenLinkWithNumber.html"
    @linkCheck = Links.new("#{FIXTURES_DIR}", brokenLinkWithNumberFilepath, HTML::Proofer.create_nokogiri(brokenLinkWithNumberFilepath))
    @linkCheck.run
    @linkCheck.issues[0].should eq("\e[34mspec/html/proofer/fixtures/brokenLinkWithNumber.html\e[0m: linking to internal hash #25-method-not-allowed that does not exist")
  end

  it 'properly resolves implicit /index.html in link paths' do
    linkToFolder = "#{FIXTURES_DIR}/linkToFolder.html"
    @linkCheck = Links.new("#{FIXTURES_DIR}", linkToFolder, HTML::Proofer.create_nokogiri(linkToFolder))
    @linkCheck.run
    @linkCheck.issues[0].should eq(nil)
  end

  it 'properly checks links to root' do
    rootLink = "#{FIXTURES_DIR}/rootLink.html"
    @linkCheck = Links.new("#{FIXTURES_DIR}", rootLink, HTML::Proofer.create_nokogiri(rootLink))
    @linkCheck.run
    @linkCheck.issues[0].should eq(nil)
  end

  it 'properly checks relative links' do
    relativeLinks = "#{FIXTURES_DIR}/relativeLinks.html"
    @linkCheck = Links.new("#{FIXTURES_DIR}", relativeLinks, HTML::Proofer.create_nokogiri(relativeLinks))
    @linkCheck.run
    @linkCheck.issues[0].should eq(nil)
  end

  it 'ignores links marked as ignore data-proofer-ignore' do
    ignorableLinks = "#{FIXTURES_DIR}/ignorableLinks.html"
    @linkCheck = Links.new("#{FIXTURES_DIR}", ignorableLinks, HTML::Proofer.create_nokogiri(ignorableLinks))
    @linkCheck.run
    @linkCheck.issues[0].should eq(nil)
  end

  it 'translates links via href_swap' do
    translatedLink = "#{FIXTURES_DIR}/linkTranslatedViaHrefSwap.html"
    @linkCheck = Links.new("#{FIXTURES_DIR}", translatedLink, HTML::Proofer.create_nokogiri(translatedLink), {:href_swap => { /\A\/articles\/([\w-]+)/ => "\\1.html" }})
    @linkCheck.run
    @linkCheck.issues[0].should eq(nil)
  end
end
