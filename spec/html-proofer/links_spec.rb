require 'spec_helper'

describe 'Links test' do
  it 'fails for broken internal hash (even if the file exists)' do
    broken_hash_external_filepath = "#{FIXTURES_DIR}/links/broken_hash_external.html"
    proofer = run_proofer(broken_hash_external_filepath, :file)
    expect(proofer.failed_tests.last).to match(%r{linking to ../images/missing_image_alt.html#asdfasfdkafl, but asdfasfdkafl does not exist})
  end

  it 'fails for broken hashes on the web when asked (even if the file exists)' do
    broken_hash_on_the_web = "#{FIXTURES_DIR}/links/broken_hash_on_the_web.html"
    proofer = run_proofer(broken_hash_on_the_web, :file, check_external_hash: true)
    expect(proofer.failed_tests.first).to match(/but the hash 'no' does not/)
  end

  it 'passes for broken hashes on the web when ignored (even if the file exists)' do
    broken_hash_on_the_web = "#{FIXTURES_DIR}/links/broken_hash_on_the_web.html"
    proofer = run_proofer(broken_hash_on_the_web, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'passes for GitHub hashes on the web when asked' do
    github_hash = "#{FIXTURES_DIR}/links/github_hash.html"
    proofer = run_proofer(github_hash, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'passes for broken hashes on the web (when we look only for 4xx)' do
    options = { only_4xx: true }
    broken_hash_on_the_web = "#{FIXTURES_DIR}/links/broken_hash_on_the_web.html"
    proofer = run_proofer(broken_hash_on_the_web, :file, options)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for broken internal hash' do
    broken_hash_internal_filepath = "#{FIXTURES_DIR}/links/broken_hash_internal.html"
    proofer = run_proofer(broken_hash_internal_filepath, :file)
    expect(proofer.failed_tests.first).to match(/linking to internal hash #noHash that does not exist/)
  end

  it 'passes when linking to the top' do
    path = "#{FIXTURES_DIR}/links/topHashInternal.html"
    proofer = run_proofer(path, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for broken external links' do
    broken_link_external_filepath = "#{FIXTURES_DIR}/links/broken_link_external.html"
    proofer = run_proofer(broken_link_external_filepath, :file)
    failure = proofer.failed_tests.first
    expect(failure).to match(/failed: response code 0/)
    # ensure lack of slash in error message
    expect(failure).to match(%r{External link http://www.asdo3IRJ395295jsingrkrg4.com failed:})
  end

  it 'passes for different filename without option' do
    broken_link_external_filepath = "#{FIXTURES_DIR}/links/file.foo"
    proofer = run_proofer(broken_link_external_filepath, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for different filenames' do
    options = { extension: '.foo' }
    broken_link_external_filepath = "#{FIXTURES_DIR}/links/file.foo"
    proofer = run_proofer(broken_link_external_filepath, :file, options)
    expect(proofer.failed_tests.first).to match(/failed: response code 0/)
  end

  it 'fails for broken internal links' do
    broken_link_internal_filepath = "#{FIXTURES_DIR}/links/broken_link_internal.html"
    proofer = run_proofer(broken_link_internal_filepath, :file)
    expect(proofer.failed_tests.first).to match(%r{internally linking to .\/notreal.html, which does not exist})
  end

  it 'fails for link with no href' do
    missing_link_href_filepath = "#{FIXTURES_DIR}/links/missing_link_href.html"
    proofer = run_proofer(missing_link_href_filepath, :file)
    expect(proofer.failed_tests.first).to match(/anchor has no href attribute/)
  end

  it 'should follow redirects' do
    link_with_redirect_filepath = "#{FIXTURES_DIR}/links/link_with_redirect.html"
    proofer = run_proofer(link_with_redirect_filepath, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails on redirects if not following' do
    link_with_redirect_filepath = "#{FIXTURES_DIR}/links/link_with_redirect.html"
    proofer = run_proofer(link_with_redirect_filepath, :file, typhoeus: { followlocation: false })
    expect(proofer.failed_tests.first).to match(/failed: 301/)
  end

  it "does not fail on redirects we're not following" do
    # this test should emit a 301--see above--but we're intentionally suppressing it
    link_with_redirect_filepath = "#{FIXTURES_DIR}/links/link_with_redirect.html"
    proofer = run_proofer(link_with_redirect_filepath, :file, only_4xx: true, typhoeus: { followlocation: false })
    expect(proofer.failed_tests).to eq []
  end

  it 'should understand https' do
    link_with_https_filepath = "#{FIXTURES_DIR}/links/link_with_https.html"
    proofer = run_proofer(link_with_https_filepath, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for broken hash links with status code numbers' do
    broken_link_with_number_filepath = "#{FIXTURES_DIR}/links/broken_link_with_number.html"
    proofer = run_proofer(broken_link_with_number_filepath, :file)
    expect(proofer.failed_tests.first).to match(/linking to internal hash #25-method-not-allowed that does not exist/)
  end

  it 'properly resolves implicit /index.html in link paths' do
    link_to_folder = "#{FIXTURES_DIR}/links/link_to_folder.html"
    proofer = run_proofer(link_to_folder, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'properly checks links to root' do
    root_link = "#{FIXTURES_DIR}/links/root_link/root_link.html"
    proofer = run_proofer(root_link, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'properly checks relative links' do
    relative_links = "#{FIXTURES_DIR}/links/relative_links.html"
    proofer = run_proofer(relative_links, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'properly checks ssl links' do
    check_ssl_links = "#{FIXTURES_DIR}/links/check_ssl_links.html"
    proofer = run_proofer(check_ssl_links, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'ignores links marked as ignore data-proofer-ignore' do
    ignorable_links = "#{FIXTURES_DIR}/links/ignorable_links.html"
    proofer = run_proofer(ignorable_links, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'ignores links via url_ignore' do
    ignorable_links = "#{FIXTURES_DIR}/links/ignorable_links_via_options.html"
    proofer = run_proofer(ignorable_links, :file, url_ignore: [%r{^http://}, /sdadsad/, '../whaadadt.html'])
    expect(proofer.failed_tests).to eq []
  end

  it 'translates links via url_swap' do
    translated_link = "#{FIXTURES_DIR}/links/link_translated_via_href_swap.html"
    proofer = run_proofer(translated_link, :file, url_swap: { %r{\A/articles/([\w-]+)} => '\\1.html' })
    expect(proofer.failed_tests).to eq []
  end

  it 'translates links via url_swap for list of links' do
    proofer = run_proofer(['www.garbalarba.com'], :links, url_swap: { /garbalarba/ => 'github' })
    expect(proofer.failed_tests).to eq []
  end

  it 'finds a mix of broken and unbroken links' do
    multiple_problems = "#{FIXTURES_DIR}/links/multiple_problems.html"
    proofer = run_proofer(multiple_problems, :file)
    expect(proofer.failed_tests.first).to match(/linking to internal hash #anadaasdadsadschor that does not exist/)
  end

  it 'ignores valid mailto links' do
    ignorable_links = "#{FIXTURES_DIR}/links/mailto_link.html"
    proofer = run_proofer(ignorable_links, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for blank mailto links' do
    blank_mail_to_link = "#{FIXTURES_DIR}/links/blank_mailto_link.html"
    proofer = run_proofer(blank_mail_to_link, :file)
    expect(proofer.failed_tests.first).to match(/mailto: contains no email address/)
  end

  it 'fails for invalid mailto links' do
    invalid_mail_to_link = "#{FIXTURES_DIR}/links/invalid_mailto_link.html"
    proofer = run_proofer(invalid_mail_to_link, :file)
    expect(proofer.failed_tests.first).to match(/mailto:octocat contains an invalid email address/)
  end

  it 'ignores valid tel links' do
    ignorable_links = "#{FIXTURES_DIR}/links/tel_link.html"
    proofer = run_proofer(ignorable_links, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for blank tel links' do
    blank_tel_link = "#{FIXTURES_DIR}/links/blank_tel_link.html"
    proofer = run_proofer(blank_tel_link, :file)
    expect(proofer.failed_tests.first).to match(/tel: contains no phone number/)
  end

  it 'ignores javascript links' do
    javascript_link = "#{FIXTURES_DIR}/links/javascript_link.html"
    proofer = run_proofer(javascript_link, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'works for valid links missing the protocol' do
    missing_protocol_link = "#{FIXTURES_DIR}/links/link_missing_protocol_valid.html"
    proofer = run_proofer(missing_protocol_link, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for invalid links missing the protocol' do
    missing_protocol_link = "#{FIXTURES_DIR}/links/link_missing_protocol_invalid.html"
    proofer = run_proofer(missing_protocol_link, :file)
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
    options = { typhoeus: { followlocation: false } }
    internal = "#{FIXTURES_DIR}/links/link_directory_without_slash.html"
    proofer = run_proofer(internal, :file, options)
    expect(proofer.failed_tests.first).to match(/without trailing slash/)
  end

  it 'ignores external links when asked' do
    options = { disable_external: true }
    external = "#{FIXTURES_DIR}/links/broken_link_external.html"
    proofer = run_proofer(external, :file, options)
    expect(proofer.failed_tests).to eq []
  end

  it 'validates links with external characters' do
    options = { disable_external: true }
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
    options = { directory_index_file: 'index.php' }
    link_pointing_to_directory = "#{FIXTURES_DIR}/links/link_pointing_to_directory.html"
    proofer = run_proofer(link_pointing_to_directory, :file, options)
    expect(proofer.failed_tests).to eq []
  end

  it "fails if directory index file doesn't exist" do
    options = { directory_index_file: 'README.md' }
    link_pointing_to_directory = "#{FIXTURES_DIR}/links/link_pointing_to_directory.html"
    proofer = run_proofer(link_pointing_to_directory, :file, options)
    expect(proofer.failed_tests.first).to match('internally linking to folder-php/, which does not exist')
  end

  it 'ensures Typhoeus options are passed' do
    options = { typhoeus: { ssl_verifypeer: false } }
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
    hash_referring_to_self = "#{FIXTURES_DIR}/links/hash_referring_to_self.html"
    proofer = run_proofer(hash_referring_to_self, :file)
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
    fixture = "#{FIXTURES_DIR}/links/broken_unix_links.html"
    proofer = run_proofer(fixture, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'passes for external UTF-8 links' do
    fixture = "#{FIXTURES_DIR}/links/utf8_link.html"
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
    fixture = "#{FIXTURES_DIR}/links/attribute_with_dash.html"
    proofer = run_proofer(fixture, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'passes for links hash-referencing itself' do
    fixture = "#{FIXTURES_DIR}/links/self_ref.html"
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
    proofer = run_proofer(non_https, :file, enforce_https: true)
    expect(proofer.failed_tests.first).to match(/ben.balter.com is not an HTTPS link/)
  end

  it 'passes for hash href when asked' do
    hash_href = "#{FIXTURES_DIR}/links/hash_href.html"
    proofer = run_proofer(hash_href, :file, allow_hash_href: true)
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
    hash_href = "#{FIXTURES_DIR}/links/encoding_link.html"
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
    translated_link = "#{FIXTURES_DIR}/links/link_translated_internal_domains.html"
    proofer = run_proofer(translated_link, :file, internal_domains: ['www.example.com', 'example.com'])
    expect(proofer.failed_tests).to eq []
  end

  it 'passes for relative links with a base' do
    relative_links = "#{FIXTURES_DIR}/links/relative_links_with_base.html"
    proofer = run_proofer(relative_links, :file)
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
    proofer = run_proofer(hash_href, :file, allow_hash_href: true)
    expect(proofer.failed_tests.length).to eq 0
  end

  it 'works with base without href' do
    base_no_href = "#{FIXTURES_DIR}/links/base_no_href.html"
    proofer = run_proofer(base_no_href, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'complains if SRI and CORS not provided' do
    file = "#{FIXTURES_DIR}/links/integrity_and_cors_not_provided.html"
    proofer = run_proofer(file, :file, check_sri: true)
    expect(proofer.failed_tests.first).to match(/SRI and CORS not provided/)
  end

  it 'complains if SRI not provided' do
    file = "#{FIXTURES_DIR}/links/cors_not_provided.html"
    proofer = run_proofer(file, :file, check_sri: true)
    expect(proofer.failed_tests.first).to match(/CORS not provided/)
  end

  it 'complains if CORS not provided' do
    file = "#{FIXTURES_DIR}/links/integrity_not_provided.html"
    proofer = run_proofer(file, :file, check_sri: true)
    expect(proofer.failed_tests.first).to match(/Integrity is missing/)
  end

  it 'is happy if SRI and CORS provided' do
    file = "#{FIXTURES_DIR}/links/integrity_and_cors_provided.html"
    proofer = run_proofer(file, :file, check_sri: true)
    expect(proofer.failed_tests).to eq []
  end

  it 'does not check local scripts' do
    file = "#{FIXTURES_DIR}/links/local_stylesheet.html"
    proofer = run_proofer(file, :file, check_sri: true)
    expect(proofer.failed_tests).to eq []
  end

  it 'timeout' do
    proofer = run_proofer(['https://www.google.com:81'], :links)
    expect(proofer.failed_tests.first).to match(/time out/)
  end

  it 'correctly handles empty href' do
    file = "#{FIXTURES_DIR}/links/empty_href.html"
    proofer = run_proofer(file, :file, check_external_hash: true)
    expect(proofer.failed_tests.length).to eq 1
  end

  it 'is not checking SRI and CORS for links with rel canonical or alternate' do
    file = "#{FIXTURES_DIR}/links/link_with_rel.html"
    proofer = run_proofer(file, :file, check_sri: true)
    expect(proofer.failed_tests).to eq []
  end
end
