require 'spec_helper'

describe 'Links test' do

  it 'fails for broken internal hash (even if the file exists)' do
    brokenHashExternalFilepath = "#{FIXTURES_DIR}/links/brokenHashExternal.html"
    proofer = run_proofer(brokenHashExternalFilepath, :file)
    expect(proofer.failed_tests.last).to match(%r{linking to ../images/missingImageAlt.html#asdfasfdkafl, but asdfasfdkafl does not exist})
  end

  it 'fails for broken hashes on the web when asked (even if the file exists)' do
    brokenHashOnTheWeb = "#{FIXTURES_DIR}/links/brokenHashOnTheWeb.html"
    proofer = run_proofer(brokenHashOnTheWeb, :file, { :check_external_hash => true} )
    expect(proofer.failed_tests.first).to match(/but the hash 'no' does not/)
  end

  it 'passes for broken hashes on the web when ignored (even if the file exists)' do
    brokenHashOnTheWeb = "#{FIXTURES_DIR}/links/brokenHashOnTheWeb.html"
    proofer = run_proofer(brokenHashOnTheWeb, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'passes for GitHub hashes on the web when asked' do
    githubHash = "#{FIXTURES_DIR}/links/githubHash.html"
    proofer = run_proofer(githubHash, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'passes for broken hashes on the web (when we look only for 4xx)' do
    options = { :only_4xx => true }
    brokenHashOnTheWeb = "#{FIXTURES_DIR}/links/brokenHashOnTheWeb.html"
    proofer = run_proofer(brokenHashOnTheWeb, :file, options)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for broken internal hash' do
    brokenHashInternalFilepath = "#{FIXTURES_DIR}/links/brokenHashInternal.html"
    proofer = run_proofer(brokenHashInternalFilepath, :file)
    expect(proofer.failed_tests.first).to match(/linking to internal hash #noHash that does not exist/)
  end

  it 'fails for broken external links' do
    brokenLinkExternalFilepath = "#{FIXTURES_DIR}/links/brokenLinkExternal.html"
    proofer = run_proofer(brokenLinkExternalFilepath, :file)
    failure = proofer.failed_tests.first
    expect(failure).to match(/failed: response code 0/)
    # ensure lack of slash in error message
    expect(failure).to match(%r{External link http://www.asdo3IRJ395295jsingrkrg4.com failed:})
  end

  it 'passes for different filename without option' do
    brokenLinkExternalFilepath = "#{FIXTURES_DIR}/links/file.foo"
    proofer = run_proofer(brokenLinkExternalFilepath, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for different filenames' do
    options = { :extension => '.foo' }
    brokenLinkExternalFilepath = "#{FIXTURES_DIR}/links/file.foo"
    proofer = run_proofer(brokenLinkExternalFilepath, :file, options)
    expect(proofer.failed_tests.first).to match(/failed: response code 0/)
  end

  it 'fails for broken internal links' do
    brokenLinkInternalFilepath = "#{FIXTURES_DIR}/links/brokenLinkInternal.html"
    proofer = run_proofer(brokenLinkInternalFilepath, :file)
    expect(proofer.failed_tests.first).to match(/internally linking to .\/notreal.html, which does not exist/)
  end

  it 'fails for link with no href' do
    missingLinkHrefFilepath = "#{FIXTURES_DIR}/links/missingLinkHref.html"
    proofer = run_proofer(missingLinkHrefFilepath, :file)
    expect(proofer.failed_tests.first).to match(/anchor has no href attribute/)
  end

  it 'should follow redirects' do
    linkWithRedirectFilepath = "#{FIXTURES_DIR}/links/linkWithRedirect.html"
    proofer = run_proofer(linkWithRedirectFilepath, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails on redirects if not following' do
    linkWithRedirectFilepath = "#{FIXTURES_DIR}/links/linkWithRedirect.html"
    proofer = run_proofer(linkWithRedirectFilepath, :file, :typhoeus => { :followlocation => false })
    expect(proofer.failed_tests.first).to match(/failed: 301/)
  end

  it "does not fail on redirects we're not following" do
    # this test should emit a 301--see above--but we're intentionally suppressing it
    linkWithRedirectFilepath = "#{FIXTURES_DIR}/links/linkWithRedirect.html"
    proofer = run_proofer(linkWithRedirectFilepath, :file, { :only_4xx => true, :typhoeus => { :followlocation => false } })
    expect(proofer.failed_tests).to eq []
  end

  it 'should understand https' do
    linkWithHttpsFilepath = "#{FIXTURES_DIR}/links/linkWithHttps.html"
    proofer = run_proofer(linkWithHttpsFilepath, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for broken hash links with status code numbers' do
    brokenLinkWithNumberFilepath = "#{FIXTURES_DIR}/links/brokenLinkWithNumber.html"
    proofer = run_proofer(brokenLinkWithNumberFilepath, :file)
    expect(proofer.failed_tests.first).to match(/linking to internal hash #25-method-not-allowed that does not exist/)
  end

  it 'properly resolves implicit /index.html in link paths' do
    linkToFolder = "#{FIXTURES_DIR}/links/linkToFolder.html"
    proofer = run_proofer(linkToFolder, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'properly checks links to root' do
    rootLink = "#{FIXTURES_DIR}/links/rootLink/rootLink.html"
    proofer = run_proofer(rootLink, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'properly checks relative links' do
    relativeLinks = "#{FIXTURES_DIR}/links/relativeLinks.html"
    proofer = run_proofer(relativeLinks, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'properly checks ssl links' do
    checkSSLLinks = "#{FIXTURES_DIR}/links/checkSSLLinks.html"
    proofer = run_proofer(checkSSLLinks, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'ignores links marked as ignore data-proofer-ignore' do
    ignorableLinks = "#{FIXTURES_DIR}/links/ignorableLinks.html"
    proofer = run_proofer(ignorableLinks, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'ignores links via url_ignore' do
    ignorableLinks = "#{FIXTURES_DIR}/links/ignorableLinksViaOptions.html"
    proofer = run_proofer(ignorableLinks, :file, { :url_ignore => [%r{^http://}, /sdadsad/, '../whaadadt.html'] })
    expect(proofer.failed_tests).to eq []
  end

  it 'translates links via url_swap' do
    translatedLink = "#{FIXTURES_DIR}/links/linkTranslatedViaHrefSwap.html"
    proofer = run_proofer(translatedLink, :file, { :url_swap => { %r{\A/articles/([\w-]+)} => "\\1.html" } })
    expect(proofer.failed_tests).to eq []
  end

  it 'translates links via url_swap for list of links' do
    proofer = run_proofer(['www.garbalarba.com'], :links, { :url_swap => { /garbalarba/ => 'github' } })
    expect(proofer.failed_tests).to eq []
  end

  it 'finds a mix of broken and unbroken links' do
    multipleProblems = "#{FIXTURES_DIR}/links/multipleProblems.html"
    proofer = run_proofer(multipleProblems, :file)
    expect(proofer.failed_tests.first).to match(/linking to internal hash #anadaasdadsadschor that does not exist/)
  end

  it 'ignores valid mailto links' do
    ignorableLinks = "#{FIXTURES_DIR}/links/mailto_link.html"
    proofer = run_proofer(ignorableLinks, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for blank mailto links' do
    blankMailToLink = "#{FIXTURES_DIR}/links/blank_mailto_link.html"
    proofer = run_proofer(blankMailToLink, :file)
    expect(proofer.failed_tests.first).to match(/mailto: contains no email address/)
  end

  it 'fails for invalid mailto links' do
    invalidMailToLink = "#{FIXTURES_DIR}/links/invalid_mailto_link.html"
    proofer = run_proofer(invalidMailToLink, :file)
    expect(proofer.failed_tests.first).to match(/mailto:octocat contains an invalid email address/)
  end

  it 'ignores valid tel links' do
    ignorableLinks = "#{FIXTURES_DIR}/links/tel_link.html"
    proofer = run_proofer(ignorableLinks, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for blank tel links' do
    blankTelLink = "#{FIXTURES_DIR}/links/blank_tel_link.html"
    proofer = run_proofer(blankTelLink, :file)
    expect(proofer.failed_tests.first).to match(/tel: contains no phone number/)
  end

  it 'ignores javascript links' do
    javascriptLink = "#{FIXTURES_DIR}/links/javascript_link.html"
    proofer = run_proofer(javascriptLink, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'works for valid links missing the protocol' do
    missingProtocolLink = "#{FIXTURES_DIR}/links/link_missing_protocol_valid.html"
    proofer = run_proofer(missingProtocolLink, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for invalid links missing the protocol' do
    missingProtocolLink = "#{FIXTURES_DIR}/links/link_missing_protocol_invalid.html"
    proofer = run_proofer(missingProtocolLink, :file)
    expect(proofer.failed_tests.first).to match(/failed: response code 0/)
  end

  it 'works for valid href within link elements' do
    head_link = "#{FIXTURES_DIR}/links/head_link_href.html"
    proofer = run_proofer(head_link, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for empty href within link elements' do
    head_link = "#{FIXTURES_DIR}/links/head_link_href_empty.html"
    proofer = run_proofer(head_link, :file)
    expect(proofer.failed_tests.first).to match(/anchor has no href attribute/)
  end

  it 'fails for absent href within link elements' do
    head_link = "#{FIXTURES_DIR}/links/head_link_href_absent.html"
    proofer = run_proofer(head_link, :file)
    expect(proofer.failed_tests.first).to match(/anchor has no href attribute/)
  end

  it 'fails for internal linking to a directory without trailing slash' do
    options = { :typhoeus => { :followlocation => false } }
    internal = "#{FIXTURES_DIR}/links/link_directory_without_slash.html"
    proofer = run_proofer(internal, :file, options)
    expect(proofer.failed_tests.first).to match(/without trailing slash/)
  end

  it 'ignores external links when asked' do
    options = { :disable_external => true }
    external = "#{FIXTURES_DIR}/links/brokenLinkExternal.html"
    proofer = run_proofer(external, :file, options)
    expect(proofer.failed_tests).to eq []
  end

  it 'validates links with external characters' do
    options = { :disable_external => true }
    external = "#{FIXTURES_DIR}/links/external_colon_link.html"
    proofer = run_proofer(external, :file, options)
    expect(proofer.failed_tests).to eq []
  end

  it 'works for array of links' do
    proofer = run_proofer(['www.github.com', 'foofoofoo.biz'], :links)
    expect(proofer.failed_tests.first).to match(/failed: response code 0/)
  end

  it 'works for broken anchors within pre' do
    anchor_pre = "#{FIXTURES_DIR}/links/anchors_in_pre.html"
    proofer = run_proofer(anchor_pre, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'works for broken link within pre' do
    link_pre = "#{FIXTURES_DIR}/links/links_in_pre.html"
    proofer = run_proofer(link_pre, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'works for pipes in the URL' do
    escape_pipes = "#{FIXTURES_DIR}/links/escape_pipes.html"
    proofer = run_proofer(escape_pipes, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for broken hash with query' do
    broken_hash = "#{FIXTURES_DIR}/links/broken_hash_with_query.html"
    proofer = run_proofer(broken_hash, :file)
    expect(proofer.failed_tests.first).to match(/linking to internal hash #example that does not exist/)
  end

  it 'passes when linking to hash on another page' do
    hash_on_another_page = "#{FIXTURES_DIR}/links/hash_on_another_page.html"
    proofer = run_proofer(hash_on_another_page, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'works for directory index file' do
    options = { :directory_index_file => "index.php" }
    link_pointing_to_directory = "#{FIXTURES_DIR}/links/link_pointing_to_directory.html"
    proofer = run_proofer(link_pointing_to_directory, :file, options)
    expect(proofer.failed_tests).to eq []
  end

  it "fails if directory index file doesn't exist" do
    options = { :directory_index_file => "README.md" }
    link_pointing_to_directory = "#{FIXTURES_DIR}/links/link_pointing_to_directory.html"
    proofer = run_proofer(link_pointing_to_directory, :file, options)
    expect(proofer.failed_tests.first).to match "internally linking to folder-php/, which does not exist"
  end

  it 'ensures Typhoeus options are passed' do
    options = { :typhoeus => { :ssl_verifypeer => false } }
    typhoeus_options_link = "#{FIXTURES_DIR}/links/ensure_typhoeus_options.html"
    proofer = run_proofer(typhoeus_options_link, :file, options)
    expect(proofer.failed_tests).to eq []
  end

  it 'works if subdirectory ends with .html' do
    with_subdirectory_html = "#{FIXTURES_DIR}/links/_site"
    proofer = run_proofer(with_subdirectory_html, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'works for hash referring to itself' do
    hashReferringToSelf = "#{FIXTURES_DIR}/links/hashReferringToSelf.html"
    proofer = run_proofer(hashReferringToSelf, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'ignores placeholder with name' do
    placeholder_with_name = "#{FIXTURES_DIR}/links/placeholder_with_name.html"
    proofer = run_proofer(placeholder_with_name, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'ignores placeholder with id' do
    placeholder_with_id = "#{FIXTURES_DIR}/links/placeholder_with_id.html"
    proofer = run_proofer(placeholder_with_id, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for placeholder with empty id' do
    empty_id = "#{FIXTURES_DIR}/links/placeholder_with_empty_id.html"
    proofer = run_proofer(empty_id, :file)
    expect(proofer.failed_tests.first).to match(/anchor has no href attribute/)
  end

  it 'ignores non-http(s) protocols' do
    other_protocols = "#{FIXTURES_DIR}/links/other_protocols.html"
    proofer = run_proofer(other_protocols, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'passes non-standard characters' do
    fixture = "#{FIXTURES_DIR}/links/non_standard_characters.html"
    proofer = run_proofer(fixture, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'does not dupe errors' do
    fixture = "#{FIXTURES_DIR}/links/nodupe.html"
    proofer = run_proofer(fixture, :file)
    expect(proofer.failed_tests.length).to eq 1
  end

  it 'passes for broken *nix links' do
    fixture = "#{FIXTURES_DIR}/links/brokenUnixLinks.html"
    proofer = run_proofer(fixture, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'passes for external UTF-8 links' do
    fixture = "#{FIXTURES_DIR}/links/utf8Link.html"
    proofer = run_proofer(fixture, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'passes for urlencoded href' do
    fixture = "#{FIXTURES_DIR}/links/urlencoded-href.html"
    proofer = run_proofer(fixture, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'reports failures for the original link, not the redirection' do
    skip 'URL seems broken now. Need to find a new one'
    fixture = "#{FIXTURES_DIR}/links/redirected_error.html"
    proofer = run_proofer(fixture, :file)
    expect(proofer.failed_tests.first).to match(/failed: 404/)
  end

  it 'does not complain for files with attributes containing dashes' do
    fixture = "#{FIXTURES_DIR}/links/attributeWithDash.html"
    proofer = run_proofer(fixture, :file)
    expect(proofer.failed_tests).to eq []
  end

  context 'automatically adding default extensions to files' do

    before :each do
      @fixture = "#{FIXTURES_DIR}/links/no_html_extension.html"
      @options = { assume_extension: true }
    end

    it 'is not enabled by default' do
      # Default behaviour does not change
      proofer = run_proofer(@fixture, :file)
      expect(proofer.failed_tests.count).to be >= 3
    end

    it 'accepts extensionless file links when enabled' do
      # With command-line option
      proofer = run_proofer(@fixture, :file, @options)
      expect(proofer.failed_tests).to eq []
    end
  end

  it 'does not complain for internal links with mismatched cases' do
    fixture = "#{FIXTURES_DIR}/links/ignores_cases.html"
    proofer = run_proofer(fixture, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'does not check links with parameters multiple times' do
    fixture = "#{FIXTURES_DIR}/links/check_just_once.html"
    proofer = run_proofer(fixture, :file)
    expect(proofer.external_urls.length).to eq 2
  end

  it 'does not explode on bad external links in files' do
    fixture = "#{FIXTURES_DIR}/links/bad_external_links.html"
    proofer = run_proofer(fixture, :file)
    expect(proofer.failed_tests.length).to eq 2
    expect(proofer.failed_tests.first).to match(/is an invalid URL/)
  end

  it 'does not explode on bad external links in arrays' do
    proofer = run_proofer(['www.github.com', 'http://127.0.0.1:____'], :links)
    expect(proofer.failed_tests.first).to match(/is an invalid URL/)
  end

  it 'passes for non-HTTPS links when not asked' do
    non_https = "#{FIXTURES_DIR}/links/non_https.html"
    proofer = run_proofer(non_https, :file)
    expect(proofer.failed_tests.length).to eq 0
  end

  it 'fails for non-HTTPS links when asked' do
    non_https = "#{FIXTURES_DIR}/links/non_https.html"
    proofer = run_proofer(non_https, :file, { :enforce_https => true } )
    expect(proofer.failed_tests.first).to match(/ben.balter.com is not an HTTPS link/)
  end

  it 'passes for hash href when asked' do
    hash_href = "#{FIXTURES_DIR}/links/hash_href.html"
    proofer = run_proofer(hash_href, :file, { :allow_hash_href => true })
    expect(proofer.failed_tests.length).to eq 0
  end

  it 'fails for hash href when not asked' do
    hash_href = "#{FIXTURES_DIR}/links/hash_href.html"
    proofer = run_proofer(hash_href, :file)
    expect(proofer.failed_tests.first).to match(/linking to internal hash # that does not exist/)
  end

  it 'fails for broken IP address links' do
    hash_href = "#{FIXTURES_DIR}/links/ip_href.html"
    proofer = run_proofer(hash_href, :file)
    expect(proofer.failed_tests.first).to match(/response code 0/)
  end

  it 'works for internal links to weird encoding IDs' do
    hash_href = "#{FIXTURES_DIR}/links/encodingLink.html"
    proofer = run_proofer(hash_href, :file)
    expect(proofer.failed_tests.length).to eq 0
  end

  it 'does not expect href for anchors in HTML5' do
    missing_href = "#{FIXTURES_DIR}/links/blank_href_html5.html"
    proofer = run_proofer(missing_href, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'does expect href for anchors in non-HTML5' do
    missing_href = "#{FIXTURES_DIR}/links/blank_href_html4.html"
    proofer = run_proofer(missing_href, :file)
    expect(proofer.failed_tests.length).to eq 1

    missing_href = "#{FIXTURES_DIR}/links/blank_href_htmlunknown.html"
    proofer = run_proofer(missing_href, :file)
    expect(proofer.failed_tests.length).to eq 1
  end

  it 'works with internal_domains' do
    translated_link = "#{FIXTURES_DIR}/links/linkTranslatedInternalDomains.html"
    proofer = run_proofer(translated_link, :file, { :internal_domains => ['www.example.com', 'example.com'] })
    expect(proofer.failed_tests).to eq []
  end

  it 'passes for relative links with a base' do
    relativeLinks = "#{FIXTURES_DIR}/links/relativeLinksWithBase.html"
    proofer = run_proofer(relativeLinks, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'does not bomb on dns-prefetch' do
    prefetch = "#{FIXTURES_DIR}/links/dns-prefetch.html"
    proofer = run_proofer(prefetch, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'ignores links when the parent element is ignored' do
    parent_ignore = "#{FIXTURES_DIR}/links/ignored_by_parent.html"
    proofer = run_proofer(parent_ignore, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'does not cgi encode link' do
    prefetch = "#{FIXTURES_DIR}/links/do_not_cgi_encode.html"
    proofer = run_proofer(prefetch, :file)
    expect(proofer.failed_tests).to eq []
 end

  it 'works with quotes in the hash href' do
    hash_href = "#{FIXTURES_DIR}/links/quote.html"
    proofer = run_proofer(hash_href, :file, { :allow_hash_href => true })
    expect(proofer.failed_tests.length).to eq 0
  end

  it 'SRI and CORS not provided' do
    file = "#{FIXTURES_DIR}/links/integrity_and_cors_not_provided.html"
    proofer = run_proofer(file, :file, {:check_sri => true})
    expect(proofer.failed_tests.first).to match(%r{SRI and CORS not provided})
  end

  it 'SRI not provided' do
    file = "#{FIXTURES_DIR}/links/cors_not_provided.html"
    proofer = run_proofer(file, :file, {:check_sri => true})
    expect(proofer.failed_tests.first).to match(%r{CORS not provided})
  end

  it 'CORS not provided' do
    file = "#{FIXTURES_DIR}/links/integrity_not_provided.html"
    proofer = run_proofer(file, :file, {:check_sri => true})
    expect(proofer.failed_tests.first).to match(%r{Integrity is missing})
  end

  it 'SRI and CORS provided' do
    file = "#{FIXTURES_DIR}/links/integrity_and_cors_provided.html"
    proofer = run_proofer(file, :file, {:check_sri => true})
    expect(proofer.failed_tests).to eq []
  end

  it 'not checking local scripts' do
    file = "#{FIXTURES_DIR}/links/local_stylesheet.html"
    proofer = run_proofer(file, :file, {:check_sri => true})
    expect(proofer.failed_tests).to eq []
  end
end
