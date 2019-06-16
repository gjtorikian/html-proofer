# frozen_string_literal: true

require 'spec_helper'

describe 'Command test' do
  it 'works with as-links' do
    output = make_bin('--as-links www.github.com,foofoofoo.biz')
    expect(output).to match('1 failure')
  end

  it 'works with alt-ignore' do
    ignorable_links = "#{FIXTURES_DIR}/images/ignorable_alt_via_options.html"
    output = make_bin('--alt-ignore /wikimedia/,gpl.png', ignorable_links)
    expect(output).to match('successfully')
  end

  it 'works with checks-to-ignore' do
    external = "#{FIXTURES_DIR}/links/file.foo"
    output = make_bin('--extension .foo --checks-to-ignore LinkCheck', external)
    expect(output).to match('successfully')
    expect(output).to_not match('LinkCheck')
  end

  it 'works with check-external-hash' do
    broken_hash_on_the_web = "#{FIXTURES_DIR}/links/broken_hash_on_the_web.html"
    output = make_bin('--check-external-hash', broken_hash_on_the_web)
    expect(output).to match('1 failure')
  end

  it 'works with directory-index-file' do
    link_pointing_to_directory = "#{FIXTURES_DIR}/links/link_pointing_to_directory.html"
    output = make_bin('--directory-index-file index.php', link_pointing_to_directory)
    expect(output).to match('successfully')
  end

  it 'works with disable-external' do
    external = "#{FIXTURES_DIR}/links/broken_link_external.html"
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
    external = "#{FIXTURES_DIR}/links/broken_hash_internal.html"
    output = make_bin("--file-ignore #{external}", external)
    expect(output).to match('successfully')
  end

  it 'works with internal-domains' do
    translated_link = "#{FIXTURES_DIR}/links/link_translated_internal_domains.html"
    output = make_bin('--internal-domains www.example.com,example.com', translated_link)
    expect(output).to match('successfully')
  end

  it 'works with url-ignore' do
    ignorable_links = "#{FIXTURES_DIR}/links/ignorable_links_via_options.html"
    output = make_bin('--url-ignore /^http:\/\//,/sdadsad/,../whaadadt.html', ignorable_links)
    expect(output).to match('successfully')
  end

  it 'works with url-swap' do
    translated_link = "#{FIXTURES_DIR}/links/link_translated_via_href_swap.html"
    output = make_bin('--url-swap "\A/articles/([\w-]+):\1.html"', translated_link)
    expect(output).to match('successfully')
  end

  it 'works with url-swap and colon' do
    translated_link = "#{FIXTURES_DIR}/links/link_translated_via_href_swap2.html"
    output = make_bin('--url-swap "http\://www.example.com:"', translated_link)
    expect(output).to match('successfully')
  end

  it 'works with only-4xx' do
    broken_hash_on_the_web = "#{FIXTURES_DIR}/links/broken_hash_on_the_web.html"
    output = make_bin('--only-4xx', broken_hash_on_the_web)
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
    broken = "#{FIXTURES_DIR}/images/empty_image_alt_text.html"
    output = make_bin('--empty-alt-ignore', broken)
    expect(output).to match('successfully')
  end

  it 'works with allow-hash-href' do
    broken = "#{FIXTURES_DIR}/links/hash_href.html"
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
        next unless line =~ /\| `#{key}`/
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
