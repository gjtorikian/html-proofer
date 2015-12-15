require 'spec_helper'

describe 'Open Graph test' do
  it 'passes for existing external url' do
    url_valid = "#{FIXTURES_DIR}/opengraph/url-valid.html"
    proofer = run_proofer(url_valid, { :check_opengraph => true })
    expect(proofer.failed_tests).to eq []
  end
  it 'fails for empty url' do
    url_valid = "#{FIXTURES_DIR}/opengraph/url-empty.html"
    proofer = run_proofer(url_valid, { :check_opengraph => true })
    expect(proofer.failed_tests.first).to match /open graph is empty and has no content attribute/
  end
  it 'passes for existing external image' do
    url_valid = "#{FIXTURES_DIR}/opengraph/image-valid.html"
    proofer = run_proofer(url_valid, { :check_opengraph => true })
    expect(proofer.failed_tests).to eq []
  end
  it 'fails for missing external image' do
    url_valid = "#{FIXTURES_DIR}/opengraph/image-invalid.html"
    proofer = run_proofer(url_valid, { :check_opengraph => true })
    expect(proofer.failed_tests.first).to match /failed: 406/
  end
end
