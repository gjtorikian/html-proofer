# frozen_string_literal: true

require 'spec_helper'

describe 'Open Graph test' do
  it 'passes for existing external url' do
    url_valid = File.join(FIXTURES_DIR, 'opengraph', 'url-valid.html')
    proofer = run_proofer(url_valid, :file, checks: ['OpenGraph'])
    expect(proofer.failed_checks).to eq []
  end

  it 'fails for missing url content attribute' do
    url_valid = File.join(FIXTURES_DIR, 'opengraph', 'url-missing.html')
    proofer = run_proofer(url_valid, :file, checks: ['OpenGraph'])
    expect(proofer.failed_checks.first.description).to match(/open graph has no content attribute/)
  end

  it 'fails for empty url' do
    url_valid = File.join(FIXTURES_DIR, 'opengraph', 'url-empty.html')
    proofer = run_proofer(url_valid, :file, checks: ['OpenGraph'])
    expect(proofer.failed_checks.first.description).to match(/open graph content attribute is empty/)
  end

  it 'fails for missing external url' do
    url_valid = File.join(FIXTURES_DIR, 'opengraph', 'url-broken.html')
    proofer = run_proofer(url_valid, :file, checks: ['OpenGraph'])
    expect(proofer.failed_checks.first.description).to match(/failed with something very wrong/)
  end

  it 'passes for existing external image' do
    url_valid = File.join(FIXTURES_DIR, 'opengraph', 'image-valid.html')
    proofer = run_proofer(url_valid, :file, checks: ['OpenGraph'])
    expect(proofer.failed_checks).to eq []
  end

  it 'fails for missing image content attribute' do
    url_valid = File.join(FIXTURES_DIR, 'opengraph', 'image-missing.html')
    proofer = run_proofer(url_valid, :file, checks: ['OpenGraph'])
    expect(proofer.failed_checks.first.description).to match(/open graph has no content attribute/)
  end

  it 'fails for empty image' do
    url_valid = File.join(FIXTURES_DIR, 'opengraph', 'image-empty.html')
    proofer = run_proofer(url_valid, :file, checks: ['OpenGraph'])
    expect(proofer.failed_checks.first.description).to match(/open graph content attribute is empty/)
  end

  it 'fails for missing external image' do
    url_valid = File.join(FIXTURES_DIR, 'opengraph', 'image-broken.html')
    proofer = run_proofer(url_valid, :file, checks: ['OpenGraph'])
    expect(proofer.failed_checks.first.description).to match(/failed/)
  end

  it 'fails for missing internal images' do
    image_internal_invalid = File.join(FIXTURES_DIR, 'opengraph', 'image-internal-broken.html')
    proofer = run_proofer(image_internal_invalid, :file, checks: ['OpenGraph'])
    expect(proofer.failed_checks.first.description).to match(/doesnotexist.png does not exist/)
  end

  it 'passes for missing external url when not asked to check' do
    url_valid = File.join(FIXTURES_DIR, 'opengraph', 'url-broken.html')
    proofer = run_proofer(url_valid, :file)
    expect(proofer.failed_checks).to eq []
  end

  it 'passes for missing external image when not asked to check' do
    url_valid = File.join(FIXTURES_DIR, 'opengraph', 'image-broken.html')
    proofer = run_proofer(url_valid, :file, check_opengraph: false)
    expect(proofer.failed_checks).to eq []
  end
end
