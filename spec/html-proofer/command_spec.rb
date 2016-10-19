require 'spec_helper'

describe 'Command test' do
  it 'works with as-links' do
    output = make_bin('--as-links www.github.com,foofoofoo.biz')
    expect(output).to match('1 failure')
  end

  it 'works with alt-ignore' do
    ignorableLinks = "#{FIXTURES_DIR}/images/ignorableAltViaOptions.html"
    output = make_bin('--alt-ignore /wikimedia/,gpl.png', ignorableLinks)
    expect(output).to match('successfully')
  end

  it 'works with checks-to-ignore' do
    external = "#{FIXTURES_DIR}/links/file.foo"
    output = make_bin('--extension .foo --checks-to-ignore LinkCheck', external)
    expect(output).to match('successfully')
    expect(output).to_not match('LinkCheck')
  end

  it 'works with check-external-hash' do
    brokenHashOnTheWeb = "#{FIXTURES_DIR}/links/brokenHashOnTheWeb.html"
    output = make_bin('--check-external-hash', brokenHashOnTheWeb)
    expect(output).to match('1 failure')
  end

  it 'works with directory-index-file' do
    link_pointing_to_directory = "#{FIXTURES_DIR}/links/link_pointing_to_directory.html"
    output = make_bin('--directory-index-file index.php', link_pointing_to_directory)
    expect(output).to match('successfully')
  end

  it 'works with disable-external' do
    external = "#{FIXTURES_DIR}/links/brokenLinkExternal.html"
    output = make_bin('--disable-external', external)
    expect(output).to match('successfully')
  end

  it 'works with extension' do
    external = "#{FIXTURES_DIR}/links/file.foo"
    output = make_bin('--extension .foo', external)
    expect(output).to match('1 failure')
    expect(output).to match('LinkCheck')
  end

  it 'works with file-ignore' do
    external = "#{FIXTURES_DIR}/links/brokenHashInternal.html"
    output = make_bin("--file-ignore #{external}", external)
    expect(output).to match('successfully')
  end

  it 'works with internal-domains' do
    translatedLink = "#{FIXTURES_DIR}/links/linkTranslatedInternalDomains.html"
    output = make_bin('--internal-domains www.example.com,example.com', translatedLink)
    expect(output).to match('successfully')
  end

  it 'works with url-ignore' do
    ignorableLinks = "#{FIXTURES_DIR}/links/ignorableLinksViaOptions.html"
    output = make_bin('--url-ignore /^http:\/\//,/sdadsad/,../whaadadt.html', ignorableLinks)
    expect(output).to match('successfully')
  end

  it 'works with url-swap' do
    translatedLink = "#{FIXTURES_DIR}/links/linkTranslatedViaHrefSwap.html"
    output = make_bin('--url-swap "\A/articles/([\w-]+):\1.html"', translatedLink)
    expect(output).to match('successfully')
  end
  
  it 'works with url-swap and colon' do
    translatedLink = "#{FIXTURES_DIR}/links/linkTranslatedViaHrefSwap2.html"
    output = make_bin('--url-swap "http\://www.example.com:"', translatedLink)
    expect(output).to match('successfully')
  end

  it 'works with only-4xx' do
    brokenHashOnTheWeb = "#{FIXTURES_DIR}/links/brokenHashOnTheWeb.html"
    output = make_bin('--only-4xx', brokenHashOnTheWeb)
    expect(output).to match('successfully')
  end

  it 'works with check-favicon' do
    broken = "#{FIXTURES_DIR}/favicon/favicon_broken.html"
    output = make_bin('--check-favicon', broken)
    expect(output).to match('1 failure')
  end

  it 'works with check-html' do
    broken = "#{FIXTURES_DIR}/html/invalid_tag.html"
    output = make_bin('--check-html --report-invalid-tags', broken)
    expect(output).to match('1 failure')
  end

  it 'works with empty-alt-ignore' do
    broken = "#{FIXTURES_DIR}/html/emptyImageAltText.html"
    output = make_bin('--empty-alt-ignore', broken)
    expect(output).to match('successfully')
  end

  it 'works with allow-hash-href' do
    broken = "#{FIXTURES_DIR}/html/href_hash.html"
    output = make_bin('--allow-hash-href', broken)
    expect(output).to match('successfully')
  end

  it 'has every option' do
    config_keys = HTMLProofer::Configuration::PROOFER_DEFAULTS.keys
    bin_file = File.read('bin/htmlproofer')
    help_output = make_bin('--help')
    readme = File.read('README.md')
    config_keys.map(&:to_s).each do |key|
      # match options
      expect(bin_file).to match(key)
      readme.each_line do |line|
        next unless line.match(/\| `#{key}`/)
        description = line.split('|')[2].strip
        description.gsub!('A hash', 'A comma-separated list')
        description.gsub!('An array', 'A comma-separated list')
        description.gsub!(/\[(.+?)\]\(.+?\)/, '\1')
        description.sub!(/\.$/, '')
        # match README description for option
        expect(help_output).to include(description)
      end
    end
  end
end
