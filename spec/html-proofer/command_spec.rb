# frozen_string_literal: true

require 'spec_helper'

describe 'Command test' do
  it 'works with as-links' do
    output = make_bin('--as-links www.github.com,foofoofoo.biz')
    expect(output).to match('1 failure')
  end

  it 'works with checks' do
    external = File.join(FIXTURES_DIR, 'links', 'file.foo') # this has a broken link
    output = make_bin("--extensions .foo --checks 'Images,Scripts' #{external}")
    expect(output).to match('successfully')
    expect(output).to_not match(/Running.+?Links/)
  end

  it 'works with check-external-hash' do
    broken_hash_on_the_web = File.join(FIXTURES_DIR, 'links', 'broken_hash_on_the_web.html')
    output = make_bin("--check-external-hash #{broken_hash_on_the_web}")
    expect(output).to match('1 failure')
  end

  it 'works with directory-index-file' do
    link_pointing_to_directory = File.join(FIXTURES_DIR, 'links', 'link_pointing_to_directory.html')
    output = make_bin("--directory-index-file index.php #{link_pointing_to_directory}")
    expect(output).to match('successfully')
  end

  it 'works with disable-external' do
    external = File.join(FIXTURES_DIR, 'links', 'broken_link_external.html')
    output = make_bin("--disable-external #{external}")
    expect(output).to match('successfully')
  end

  it 'works with extensions' do
    external = File.join(FIXTURES_DIR, 'links', 'file.foo')
    output = make_bin("--extensions .foo #{external}")
    expect(output).to match('1 failure')
    expect(output).to match('Links')
  end

  it 'works with ignore-files' do
    external = File.join(FIXTURES_DIR, 'links', 'broken_hash_internal.html')
    output = make_bin("--ignore-files #{external} #{external}")
    expect(output).to match('successfully')
  end

  it 'works with ignore-urls' do
    ignorable_links = File.join(FIXTURES_DIR, 'links', 'ignorable_links_via_options.html')
    output = make_bin("--ignore-urls /^http:\/\//,/sdadsad/,../whaadadt.html #{ignorable_links}")
    expect(output).to match('successfully')
  end

  it 'works with swap-urls' do
    translated_link = File.join(FIXTURES_DIR, 'links', 'link_translated_via_href_swap.html')
    output = make_bin(%|--swap-urls "\\A/articles/([\\w-]+):\\1.html" #{translated_link}|)
    expect(output).to match('successfully')
  end

  it 'works with swap-urls and colon' do
    translated_link = File.join(FIXTURES_DIR, 'links', 'link_translated_via_href_swap2.html')
    output = make_bin(%(--swap-urls "http\\://www.example.com:" #{translated_link}))
    expect(output).to match('successfully')
  end

  it 'works with only-4xx' do
    broken_hash_on_the_web = File.join(FIXTURES_DIR, 'links', 'broken_hash_on_the_web.html')
    output = make_bin("--only-4xx #{broken_hash_on_the_web}")
    expect(output).to match('successfully')
  end

  it 'works with check-favicon' do
    broken = File.join(FIXTURES_DIR, 'favicon', 'internal_favicon_broken.html')
    output = make_bin("--checks 'Favicon' #{broken}")
    expect(output).to match('1 failure')
  end

  it 'works with empty-alt-ignore' do
    broken = File.join(FIXTURES_DIR, 'images', 'empty_image_alt_text.html')
    output = make_bin("--empty-alt-ignore #{broken}")
    expect(output).to match('successfully')
  end

  it 'works with allow-hash-href' do
    broken = File.join(FIXTURES_DIR, 'links', 'hash_href.html')
    output = make_bin("--allow-hash-href #{broken}")
    expect(output).to match('successfully')
  end

  it 'works with swap-attributes' do
    custom_data_src_check = File.join(FIXTURES_DIR, 'images', 'data_src_attribute.html')
    output = make_bin("#{custom_data_src_check}  --swap-attributes '{\"img\": [[\"src\", \"data-src\"]] }'")
    expect(output).to match('successfully')
  end

  it 'navigates above itself in a subdirectory' do
    real_link = File.join(FIXTURES_DIR, 'links', 'root_folder/documentation-from-my-project/')
    output = make_bin("--root-dir #{File.join(FIXTURES_DIR, 'links', 'root_folder/')} #{real_link}")
    expect(output).to match('successfully')
  end

  it 'has every option for proofer defaults' do
    match_command_help(HTMLProofer::Configuration::PROOFER_DEFAULTS)
  end

  context 'nested options' do
    it 'supports typhoeus' do
      link_with_redirect_filepath = File.join(FIXTURES_DIR, 'links', 'link_with_redirect.html')
      output = make_bin("#{link_with_redirect_filepath} --typhoeus '{ \"followlocation\": false }'")
      expect(output).to match(/failed/)
    end

    it 'has only one UA' do
      http = make_bin(%|--typhoeus='{"verbose":true,"headers":{"User-Agent":"Mozilla/5.0 (Macintosh; My New User-Agent)"}}' --as-links https://linkedin.com|)
      expect(http.scan(/User-Agent: Typhoeus/).count).to eq 0
      expect(http.scan(%r{User-Agent: Mozilla/5.0 \(Macintosh; My New User-Agent\)}i).count).to eq 2
    end

    it 'supports hydra' do
      http = make_bin(%(--hydra '{"max_concurrency": 5}' http://www.github.com --as-links))
      expect(http.scan(/max_concurrency is invalid/).count).to eq 0
    end
  end
end

def match_command_help(config)
  config_keys = config.keys
  bin_file = File.read('bin/htmlproofer')
  help_output = make_bin('--help')
  readme = File.read('README.md')

  config_keys.map(&:to_s).each do |key|
    # match options
    expect(bin_file).to match(key)
    matched = false
    readme.each_line do |line|
      next unless /\| `#{key}`/.match?(line)

      matched = true
      description = line.split('|')[2].strip
      description.gsub!('A hash', 'A comma-separated list')
      description.gsub!('An array', 'A comma-separated list')
      description.gsub!(/\[(.+?)\]\(.+?\)/, '\1')
      description.sub!(/\.$/, '')

      # match README description for option
      expect(help_output).to include(description)
    end

    expect(matched).to be(true), "Could not find `#{key}` explained in README!" unless matched
  end
end
