require "spec_helper"

describe "Links tests" do

  it "fails for broken external hash (even if the file exists)" do
    brokenHashExternalFilepath = "#{FIXTURES_DIR}/brokenHashExternal.html"
    @linkCheck = Links.new(brokenHashExternalFilepath, HTML::Proofer.create_nokogiri(brokenHashExternalFilepath))
    @linkCheck.run
    @linkCheck.issues[1].should eq("spec/html/proofer/fixtures/brokenHashExternal.html".blue + ": linking to ./missingImageAlt.html#asdfasfdkafl, but asdfasfdkafl does not exist")
  end

  it "fails for broken internal hash" do
    brokenHashInternalFilepath = "#{FIXTURES_DIR}/brokenHashInternal.html"
    @linkCheck = Links.new(brokenHashInternalFilepath, HTML::Proofer.create_nokogiri(brokenHashInternalFilepath))
    @linkCheck.run
    @linkCheck.issues[0].should eq("spec/html/proofer/fixtures/brokenHashInternal.html".blue + ": linking to an internal hash called noHash that does not exist")
  end

  it "fails for broken external links" do
    brokenLinkExternalFilepath = "#{FIXTURES_DIR}/brokenLinkExternal.html"
    @linkCheck = Links.new(brokenLinkExternalFilepath, HTML::Proofer.create_nokogiri(brokenLinkExternalFilepath))
    @linkCheck.run
    @linkCheck.hydra.run
    @linkCheck.issues[0].sub!(/ #<Typhoeus::Response:[\w]+>/, "")
    @linkCheck.issues[0].should eq("spec/html/proofer/fixtures/brokenLinkExternal.html".blue + ": externally linking to http://www.asdo3IRJ395295jsingrkrg4.com, which does not exist")
  end

  it "fails for broken internal links" do
    brokenLinkInternalFilepath = "#{FIXTURES_DIR}/brokenLinkInternal.html"
    @linkCheck = Links.new(brokenLinkInternalFilepath, HTML::Proofer.create_nokogiri(brokenLinkInternalFilepath))
    @linkCheck.run
    @linkCheck.issues[0].should eq("spec/html/proofer/fixtures/brokenLinkInternal.html".blue + ": internally linking to spec/html/proofer/fixtures/./notreal.html, which does not exist")
  end

  it "fails for link with no href" do
    missingLinkHrefFilepath = "#{FIXTURES_DIR}/missingLinkHref.html"
    @linkCheck = Links.new(missingLinkHrefFilepath, HTML::Proofer.create_nokogiri(missingLinkHrefFilepath))
    @linkCheck.run
    @linkCheck.issues[0].should eq("spec/html/proofer/fixtures/missingLinkHref.html".blue + ": link has no href attribute")
  end

  it "should follow redirects" do
    linkWithRedirectFilepath = "#{FIXTURES_DIR}/linkWithRedirect.html"
    @linkCheck = Links.new(linkWithRedirectFilepath, HTML::Proofer.create_nokogiri(linkWithRedirectFilepath))
    @linkCheck.run
    @linkCheck.issues[0].should eq(nil)
  end

  it "should understand https" do
    linkWithHttpsFilepath = "#{FIXTURES_DIR}/linkWithHttps.html"
    @linkCheck = Links.new(linkWithHttpsFilepath, HTML::Proofer.create_nokogiri(linkWithHttpsFilepath))
    @linkCheck.run
    @linkCheck.issues[0].should eq(nil)
  end

  it "fails for broken hash links with status code numbers" do
    brokenLinkWithNumberFilepath = "#{FIXTURES_DIR}/brokenLinkWithNumber.html"
    @linkCheck = Links.new(brokenLinkWithNumberFilepath, HTML::Proofer.create_nokogiri(brokenLinkWithNumberFilepath))
    @linkCheck.run
    @linkCheck.issues[0].should eq(nil)
  end

  it 'properly resolves implicit /index.html in link paths' do
    linkToFolder = "#{FIXTURES_DIR}/linkToFolder.html"
    @linkCheck = Links.new(linkToFolder, HTML::Proofer.create_nokogiri(linkToFolder))
    @linkCheck.run
    @linkCheck.issues[0].should eq(nil)
  end

  it 'properly checks links to root' do
    rootLink = "#{FIXTURES_DIR}/rootLink.html"
    @linkCheck = Links.new(rootLink, HTML::Proofer.create_nokogiri(rootLink))
    @linkCheck.run
    @linkCheck.issues[0].should eq(nil)
  end
end
