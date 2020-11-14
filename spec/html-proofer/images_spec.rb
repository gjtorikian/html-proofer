# frozen_string_literal: true

require 'spec_helper'

describe 'Images test' do
  it 'passes for existing external images' do
    external_image_filepath = "#{FIXTURES_DIR}/images/existing_image_external.html"
    proofer = run_proofer(external_image_filepath, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for image without alt attribute' do
    missing_alt_filepath = "#{FIXTURES_DIR}/images/missing_image_alt.html"
    proofer = run_proofer(missing_alt_filepath, :file)
    expect(proofer.failed_tests.first).to match(/gpl.png does not have an alt attribute/)
  end

  it 'fails for image with an empty alt attribute' do
    missing_alt_filepath = "#{FIXTURES_DIR}/images/missing_image_alt_text.html"
    proofer = run_proofer(missing_alt_filepath, :file)
    expect(proofer.failed_tests.first).to match(/gpl.png does not have an alt attribute/)
  end

  it 'fails for image with nothing but spaces in alt attribute' do
    empty_alt_filepath = "#{FIXTURES_DIR}/images/empty_image_alt_text.html"
    proofer = run_proofer(empty_alt_filepath, :file)
    expect(proofer.failed_tests.first).to match(/gpl.png does not have an alt attribute/)
    expect(proofer.failed_tests.length).to eq(4)
  end

  it 'passes when ignoring image with nothing but spaces in alt attribute' do
    empty_alt_filepath = "#{FIXTURES_DIR}/images/empty_image_alt_text.html"
    proofer = run_proofer(empty_alt_filepath, :file, alt_ignore: [/.+/])
    expect(proofer.failed_tests).to eq []
  end

  it 'passes for images with spaces all over' do
    spaced_filepath = "#{FIXTURES_DIR}/images/spaced_image.html"
    proofer = run_proofer(spaced_filepath, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for missing external images' do
    external_image_filepath = "#{FIXTURES_DIR}/images/missing_image_external.html"
    proofer = run_proofer(external_image_filepath, :file)
    expect(proofer.failed_tests.first).to match(/failed: response code 0/)
  end

  it 'fails for missing internal images even when alt_ignore is set' do
    internal_image_filepath = "#{FIXTURES_DIR}/images/missing_image_internal.html"
    proofer = run_proofer(internal_image_filepath, :file, alt_ignore: [/.*/])
    expect(proofer.failed_tests.first).to match(/doesnotexist.png does not exist/)
  end

  it 'fails for missing internal images' do
    internal_image_filepath = "#{FIXTURES_DIR}/images/missing_image_internal.html"
    proofer = run_proofer(internal_image_filepath, :file)
    expect(proofer.failed_tests.first).to match(/doesnotexist.png does not exist/)
  end

  it 'fails for image with no src' do
    image_src_filepath = "#{FIXTURES_DIR}/images/missing_image_src.html"
    proofer = run_proofer(image_src_filepath, :file)
    expect(proofer.failed_tests.first).to match(/image has no src or srcset attribute/)
  end

  it 'fails for image with default mac filename' do
    terrible_image_name = "#{FIXTURES_DIR}/images/terrible_image_name.html"
    proofer = run_proofer(terrible_image_name, :file)
    expect(proofer.failed_tests.first).to match(/image has a terrible filename/)
  end

  it 'ignores images marked as ignore data-proofer-ignore' do
    ignorable_images = "#{FIXTURES_DIR}/images/ignorableImages.html"
    proofer = run_proofer(ignorable_images, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'ignores images via url_ignore' do
    ignorable_image = "#{FIXTURES_DIR}/images/terrible_image_name.html"
    proofer = run_proofer(ignorable_image, :file, url_ignore: [%r{./Screen.+}])
    expect(proofer.failed_tests).to eq []
  end

  it 'translates images via url_swap' do
    translated_link = "#{FIXTURES_DIR}/images/terrible_image_name.html"
    proofer = run_proofer(translated_link, :file, url_swap: { %r{./Screen.+} => 'gpl.png' })
    expect(proofer.failed_tests).to eq []
  end

  it 'properly checks relative images' do
    relative_images = "#{FIXTURES_DIR}/images/root_relative_images.html"
    proofer = run_proofer(relative_images, :file)
    expect(proofer.failed_tests).to eq []

    relative_images = "#{FIXTURES_DIR}/resources/books/nestedRelativeImages.html"
    proofer = run_proofer(relative_images, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'properly ignores data URI images' do
    data_uri_image = "#{FIXTURES_DIR}/images/working_data_uri_image.html"
    proofer = run_proofer(data_uri_image, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'works for valid images missing the protocol' do
    missing_protocol_link = "#{FIXTURES_DIR}/images/image_missing_protocol_valid.html"
    proofer = run_proofer(missing_protocol_link, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for invalid images missing the protocol' do
    missing_protocol_link = "#{FIXTURES_DIR}/images/image_missing_protocol_invalid.html"
    proofer = run_proofer(missing_protocol_link, :file)
    expect(proofer.failed_tests.first).to match(/failed: 404/)
  end

  it 'properly checks relative links' do
    relative_links = "#{FIXTURES_DIR}/images/relative_to_self.html"
    proofer = run_proofer(relative_links, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'properly ignores missing alt tags when asked' do
    ignoreable_links = "#{FIXTURES_DIR}/images/ignorable_alt_via_options.html"
    proofer = run_proofer(ignoreable_links, :file, alt_ignore: [/wikimedia/, 'gpl.png'])
    expect(proofer.failed_tests).to eq []
  end

  it 'properly ignores missing alt tags, but not all URLs, when asked' do
    ignoreable_links = "#{FIXTURES_DIR}/images/ignore_alt_but_not_link.html"
    proofer = run_proofer(ignoreable_links, :file, alt_ignore: [/.*/])
    expect(proofer.failed_tests.first).to match(/failed: response code 0/)
    expect(proofer.failed_tests.first).to_not match(/does not have an alt attribute/)
  end

  it 'properly ignores empty alt attribute when empty_alt_ignore set' do
    missing_alt_filepath = "#{FIXTURES_DIR}/images/empty_image_alt_text.html"
    proofer = run_proofer(missing_alt_filepath, :file, empty_alt_ignore: true)
    expect(proofer.failed_tests).to eq []
  end

  # it 'properly ignores empty alt attributes, but not missing alt attributes, when empty_alt_ignore set' do
  #   missing_alt_filepath = "#{FIXTURES_DIR}/images/missing_image_alt.html"
  #   proofer = run_proofer(missing_alt_filepath, :file, empty_alt_ignore: true)
  #   expect(proofer.failed_tests.first).to match(/gpl.png does not have an alt attribute/)
  # end

  it 'works for images with a srcset' do
    src_set_check = "#{FIXTURES_DIR}/images/src_set_check.html"
    proofer = run_proofer(src_set_check, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'skips missing alt tag for images marked as aria-hidden' do
    src_set_check = "#{FIXTURES_DIR}/images/aria_hidden.html"
    proofer = run_proofer(src_set_check, :file)
    expect(proofer.failed_tests.size).to eq 1
    expect(proofer.failed_tests.first).to match(%r{image ./gpl.png does not have an alt attribute})
  end

  it 'fails for images with a srcset but missing alt' do
    src_set_missing_alt = "#{FIXTURES_DIR}/images/src_set_missing_alt.html"
    proofer = run_proofer(src_set_missing_alt, :file)
    expect(proofer.failed_tests.first).to match(/image gpl.png does not have an alt attribute/)
  end

  it 'fails for images with an alt but missing src or srcset' do
    src_set_missing_alt = "#{FIXTURES_DIR}/images/src_set_missing_image.html"
    proofer = run_proofer(src_set_missing_alt, :file)
    expect(proofer.failed_tests.first).to match(/internal image notreal.png does not exist/)
  end

  it 'properly ignores missing alt tags when asked for srcset' do
    ignoreable_links = "#{FIXTURES_DIR}/images/src_set_ignorable.html"
    proofer = run_proofer(ignoreable_links, :file, alt_ignore: [/wikimedia/, 'gpl.png'])
    expect(proofer.failed_tests).to eq []
  end

  it 'translates src via url_swap' do
    translate_src = "#{FIXTURES_DIR}/images/replace_abs_url_src.html"
    proofer = run_proofer(translate_src, :file, url_swap: { %r{^http://baseurl.com} => '' })
    expect(proofer.failed_tests).to eq []
  end

  it 'passes for HTTP images when not asked' do
    http    = "#{FIXTURES_DIR}/images/src_http.html"
    proofer = run_proofer(http, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for HTTP images when asked' do
    http    = "#{FIXTURES_DIR}/images/src_http.html"
    proofer = run_proofer(http, :file, check_img_http: true)
    expect(proofer.failed_tests.first).to match(/uses the http scheme/)
  end

  it 'properly checks relative images with base' do
    relative_images = "#{FIXTURES_DIR}/images/relative_with_base.html"
    proofer = run_proofer(relative_images, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'ignores semicolon outside attribute name' do
    relative_images = "#{FIXTURES_DIR}/images/semicolon.html"
    proofer = run_proofer(relative_images, :file)
    expect(proofer.failed_tests).to eq []
  end
end
