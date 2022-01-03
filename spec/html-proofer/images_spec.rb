# frozen_string_literal: true

require 'spec_helper'

describe 'Images test' do
  it 'passes for existing external images' do
    external_image_filepath = File.join(FIXTURES_DIR, 'images', 'existing_image_external.html')
    proofer = run_proofer(external_image_filepath, :file)
    expect(proofer.failed_checks).to eq []
  end

  it 'fails for image without alt attribute' do
    missing_alt_filepath = File.join(FIXTURES_DIR, 'images', 'missing_image_alt.html')
    proofer = run_proofer(missing_alt_filepath, :file)
    expect(proofer.failed_checks.first.description).to match(/gpl.png does not have an alt attribute/)
  end

  it 'fails for image with an empty alt attribute' do
    missing_alt_filepath = File.join(FIXTURES_DIR, 'images', 'missing_image_alt_text.html')
    proofer = run_proofer(missing_alt_filepath, :file)
    expect(proofer.failed_checks.first.description).to match(/gpl.png does not have an alt attribute/)
  end

  it 'fails for image with nothing but spaces in alt attribute' do
    empty_alt_filepath = File.join(FIXTURES_DIR, 'images', 'empty_image_alt_text.html')
    proofer = run_proofer(empty_alt_filepath, :file)
    expect(proofer.failed_checks.first.description).to match(/gpl.png does not have an alt attribute/)
    expect(proofer.failed_checks.length).to eq(4)
  end

  it 'passes when ignoring image with nothing but spaces in alt attribute' do
    empty_alt_filepath = File.join(FIXTURES_DIR, 'images', 'empty_image_alt_text.html')
    proofer = run_proofer(empty_alt_filepath, :file, ignore_urls: [/.+/])
    expect(proofer.failed_checks).to eq []
  end

  it 'passes for missing internal images even when ignore_urls is set' do
    internal_image_filepath = File.join(FIXTURES_DIR, 'images', 'missing_image_internal.html')
    proofer = run_proofer(internal_image_filepath, :file, ignore_urls: [/.*/])
    expect(proofer.failed_checks).to eq []
  end

  it 'passes for images with spaces all over' do
    spaced_filepath = File.join(FIXTURES_DIR, 'images', 'spaced_image.html')
    proofer = run_proofer(spaced_filepath, :file)
    expect(proofer.failed_checks).to eq []
  end

  it 'fails for missing external images' do
    external_image_filepath = File.join(FIXTURES_DIR, 'images', 'missing_image_external.html')
    proofer = run_proofer(external_image_filepath, :file)
    expect(proofer.failed_checks.first.description).to match(/failed with something very wrong/)
  end

  it 'fails for missing internal images' do
    internal_image_filepath = File.join(FIXTURES_DIR, 'images', 'missing_image_internal.html')
    proofer = run_proofer(internal_image_filepath, :file)
    expect(proofer.failed_checks.first.description).to match(/doesnotexist.png does not exist/)
  end

  it 'fails for image with no src' do
    image_src_filepath = File.join(FIXTURES_DIR, 'images', 'missing_image_src.html')
    proofer = run_proofer(image_src_filepath, :file)
    expect(proofer.failed_checks.first.description).to match(/image has no src or srcset attribute/)
  end

  it 'fails for image with default macOS filename' do
    terrible_image_name = File.join(FIXTURES_DIR, 'images', 'terrible_image_name.html')
    proofer = run_proofer(terrible_image_name, :file)
    expect(proofer.failed_checks.first.description).to match(/image has a terrible filename/)
  end

  it 'ignores images marked as ignore data-proofer-ignore' do
    ignorable_images = File.join(FIXTURES_DIR, 'images', 'ignorableImages.html')
    proofer = run_proofer(ignorable_images, :file)
    expect(proofer.failed_checks).to eq []
  end

  it 'ignores images via ignore_urls' do
    ignorable_image = File.join(FIXTURES_DIR, 'images', 'terrible_image_name.html')
    proofer = run_proofer(ignorable_image, :file, ignore_urls: [%r{./Screen.+}])
    expect(proofer.failed_checks).to eq []
  end

  it 'translates images via swap_urls' do
    translated_link = File.join(FIXTURES_DIR, 'images', 'terrible_image_name.html')
    proofer = run_proofer(translated_link, :file, swap_urls: { %r{./Screen.+} => 'gpl.png' })
    expect(proofer.failed_checks).to eq []
  end

  it 'properly checks relative images' do
    relative_images = File.join(FIXTURES_DIR, 'images', 'root_relative_images.html')
    proofer = run_proofer(relative_images, :file)
    expect(proofer.failed_checks).to eq []

    relative_images = File.join(FIXTURES_DIR, 'resources', 'books', 'nestedRelativeImages.html')
    proofer = run_proofer(relative_images, :file)
    expect(proofer.failed_checks).to eq []
  end

  it 'properly ignores data URI images' do
    data_uri_image = File.join(FIXTURES_DIR, 'images', 'working_data_uri_image.html')
    proofer = run_proofer(data_uri_image, :file)
    expect(proofer.failed_checks).to eq []
  end

  it 'works for valid images missing the protocol' do
    missing_protocol_link = File.join(FIXTURES_DIR, 'images', 'image_missing_protocol_valid.html')
    proofer = run_proofer(missing_protocol_link, :file)
    expect(proofer.failed_checks).to eq []
  end

  it 'fails for invalid images missing the protocol' do
    missing_protocol_link = File.join(FIXTURES_DIR, 'images', 'image_missing_protocol_invalid.html')
    proofer = run_proofer(missing_protocol_link, :file)
    expect(proofer.failed_checks.first.description).to match(/failed/)
  end

  it 'properly checks relative links' do
    relative_links = File.join(FIXTURES_DIR, 'images', 'relative_to_self.html')
    proofer = run_proofer(relative_links, :file)
    expect(proofer.failed_checks).to eq []
  end

  it 'properly ignores missing alt tags when asked' do
    ignoreable_links = File.join(FIXTURES_DIR, 'images', 'ignorable_alt_via_options.html')
    proofer = run_proofer(ignoreable_links, :file, ignore_urls: [/wikimedia/, 'gpl.png'])
    expect(proofer.failed_checks).to eq []
  end

  it 'properly ignores missing alt tags when asked' do
    ignoreable_links = File.join(FIXTURES_DIR, 'images', 'ignore_alt_but_not_link.html')
    proofer = run_proofer(ignoreable_links, :file, ignore_urls: [/.*/])
    expect(proofer.failed_checks).to eq []
  end

  it 'properly ignores empty alt attribute when ignore_missing_alt set' do
    missing_alt_filepath = File.join(FIXTURES_DIR, 'images', 'empty_image_alt_text.html')
    proofer = run_proofer(missing_alt_filepath, :file, ignore_missing_alt: true)
    expect(proofer.failed_checks).to eq []
  end

  it 'works for images with a srcset' do
    src_set_check = File.join(FIXTURES_DIR, 'images', 'src_set_check.html')
    proofer = run_proofer(src_set_check, :file)
    expect(proofer.failed_checks.length).to eq 2
  end

  it 'skips missing alt tag for images marked as aria-hidden' do
    src_set_check = File.join(FIXTURES_DIR, 'images', 'aria_hidden.html')
    proofer = run_proofer(src_set_check, :file)
    expect(proofer.failed_checks.size).to eq 1
    expect(proofer.failed_checks.first.description).to match(%r{image ./gpl.png does not have an alt attribute})
  end

  it 'fails for images with a srcset but missing alt' do
    src_set_missing_alt = File.join(FIXTURES_DIR, 'images', 'src_set_missing_alt.html')
    proofer = run_proofer(src_set_missing_alt, :file)
    expect(proofer.failed_checks.first.description).to match(/image gpl.png does not have an alt attribute/)
  end

  it 'fails for images with an alt but missing src or srcset' do
    src_set_missing_alt = File.join(FIXTURES_DIR, 'images', 'src_set_missing_image.html')
    proofer = run_proofer(src_set_missing_alt, :file)
    expect(proofer.failed_checks.first.description).to match(/image has no src or srcset attribute/)
  end

  it 'properly ignores missing alt tags when asked for srcset' do
    ignoreable_links = File.join(FIXTURES_DIR, 'images', 'src_set_ignorable.html')
    proofer = run_proofer(ignoreable_links, :file, ignore_urls: [/wikimedia/, 'gpl.png'])
    expect(proofer.failed_checks).to eq []
  end

  it 'translates src via swap_urls' do
    translate_src = File.join(FIXTURES_DIR, 'images', 'replace_abs_url_src.html')
    proofer = run_proofer(translate_src, :file, swap_urls: { %r{^http://baseurl.com} => '' })
    expect(proofer.failed_checks).to eq []
  end

  it 'passes for HTTP images when asked' do
    http    = File.join(FIXTURES_DIR, 'images', 'src_http.html')
    proofer = run_proofer(http, :file, enforce_https: false)
    expect(proofer.failed_checks).to eq []
  end

  it 'fails for HTTP images when not asked' do
    http    = File.join(FIXTURES_DIR, 'images', 'src_http.html')
    proofer = run_proofer(http, :file)
    expect(proofer.failed_checks.first.description).to match(/uses the http scheme/)
  end

  it 'properly checks relative images with base' do
    relative_images = File.join(FIXTURES_DIR, 'images', 'relative_with_base.html')
    proofer = run_proofer(relative_images, :file)
    expect(proofer.failed_checks).to eq []
  end

  it 'ignores semicolon outside attribute name' do
    relative_images = File.join(FIXTURES_DIR, 'images', 'semicolon.html')
    proofer = run_proofer(relative_images, :file)
    expect(proofer.failed_checks).to eq []
  end

  it 'supports multiple srcsets when passes' do
    relative_images = File.join(FIXTURES_DIR, 'images', 'multiple_srcset_success.html')
    proofer = run_proofer(relative_images, :file)
    expect(proofer.failed_checks).to eq []
  end

  it 'supports multiple srcsets when fails' do
    relative_images = File.join(FIXTURES_DIR, 'images', 'multiple_srcset_failure.html')
    proofer = run_proofer(relative_images, :file)
    expect(proofer.failed_checks.first.description).to eq 'internal image /uploads/150-marie-lloyd.jpg 1.5x does not exist'
  end

  it 'works for images with a swapped data attribute src' do
    custom_data_src_check = "#{FIXTURES_DIR}/images/data_src_attribute.html"
    proofer = run_proofer(custom_data_src_check, :file, swap_attributes: { 'img' => [%w[src data-src]] })
    expect(proofer.failed_checks).to eq []
  end

  it 'breaks for images with a swapped attribute that does not exist' do
    custom_data_src_check = "#{FIXTURES_DIR}/images/data_src_attribute.html"
    proofer = run_proofer(custom_data_src_check, :file, swap_attributes: { 'img' => [%w[src foobar]] })
    expect(proofer.failed_checks.length).to eq 1
  end
end
