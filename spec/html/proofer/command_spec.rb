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

  it 'works with ext' do
    external = "#{FIXTURES_DIR}/links/file.foo"
    output = make_bin('--ext .foo', external)
    expect(output).to match('1 failure')
  end

  it 'works with file-ignore' do
    external = "#{FIXTURES_DIR}/links/brokenHashInternal.html"
    output = make_bin("--file-ignore #{external}", external)
    expect(output).to match('successfully')
  end

  it 'works with href-ignore' do
    ignorableLinks = "#{FIXTURES_DIR}/links/ignorableLinksViaOptions.html"
    output = make_bin('--href-ignore /^http:\/\//,/sdadsad/,../whaadadt.html', ignorableLinks)
    expect(output).to match('successfully')
  end

  it 'works with href-swap' do
    translatedLink = "#{FIXTURES_DIR}/links/linkTranslatedViaHrefSwap.html"
    output = make_bin('--href-swap "\A/articles/([\w-]+):\1.html"', translatedLink)
    expect(output).to match('successfully')
  end

  it 'works with only-4xx' do
    brokenHashOnTheWeb = "#{FIXTURES_DIR}/links/brokenHashOnTheWeb.html"
    output = make_bin('--only-4xx', brokenHashOnTheWeb)
    expect(output).to match('successfully')
  end

  it 'works with validate-favicon' do
    broken = "#{FIXTURES_DIR}/favicon/favicon_broken.html"
    output = make_bin('--validate-favicon', broken)
    expect(output).to match('1 failure')
  end

  it 'works with validate-html' do
    broken = "#{FIXTURES_DIR}/html/invalid_tag.html"
    output = make_bin('--validate-html', broken)
    expect(output).to match('1 failure')
  end
end
