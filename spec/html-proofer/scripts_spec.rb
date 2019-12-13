# frozen_string_literal: true

require 'spec_helper'

describe 'Scripts test' do
  it 'fails for broken external src' do
    file = "#{FIXTURES_DIR}/scripts/script_broken_external.html"
    proofer = run_proofer(file, :file)
    expect(proofer.failed_tests.first).to match(/failed: response code 0/)
  end

  it 'works for valid internal src' do
    file = "#{FIXTURES_DIR}/scripts/script_valid_internal.html"
    proofer = run_proofer(file, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for missing internal src' do
    file = "#{FIXTURES_DIR}/scripts/script_missing_internal.html"
    proofer = run_proofer(file, :file)
    expect(proofer.failed_tests.length).to eq 1
    expect(proofer.failed_tests.first).to include('spec/html-proofer/fixtures/scripts/script_missing_internal.html: internal script doesnotexist.js does not exist (line 5)')
  end

  it 'works for present content' do
    file = "#{FIXTURES_DIR}/scripts/script_content.html"
    proofer = run_proofer(file, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for absent content' do
    file = "#{FIXTURES_DIR}/scripts/script_content_absent.html"
    proofer = run_proofer(file, :file)
    expect(proofer.failed_tests.first).to match(/script is empty and has no src attribute/)
  end

  it 'works for broken script within pre' do
    script_pre = "#{FIXTURES_DIR}/scripts/script_in_pre.html"
    proofer = run_proofer(script_pre, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'ignores links via url_ignore' do
    ignorable_links = "#{FIXTURES_DIR}/scripts/ignorable_links_via_options.html"
    proofer = run_proofer(ignorable_links, :file, url_ignore: [%r{/assets/.*(js|css|png|svg)}])
    expect(proofer.failed_tests).to eq []
  end

  it 'translates src via url_swap' do
    file = "#{FIXTURES_DIR}/scripts/script_abs_url.html"
    proofer = run_proofer(file, :file, url_swap: { %r{^http://example.com} => '' })
    expect(proofer.failed_tests).to eq []
  end

  it 'is unhappy if SRI and CORS not provided' do
    file = "#{FIXTURES_DIR}/scripts/integrity_and_cors_not_provided.html"
    proofer = run_proofer(file, :file, check_sri: true)
    expect(proofer.failed_tests.first).to match(/SRI and CORS not provided/)
  end

  it 'is unhappy if SRI not provided' do
    file = "#{FIXTURES_DIR}/scripts/cors_not_provided.html"
    proofer = run_proofer(file, :file, check_sri: true)
    expect(proofer.failed_tests.first).to match(/CORS not provided/)
  end

  it 'is unhappy if CORS not provided' do
    file = "#{FIXTURES_DIR}/scripts/integrity_not_provided.html"
    proofer = run_proofer(file, :file, check_sri: true)
    expect(proofer.failed_tests.first).to match(/Integrity is missing/)
  end

  it 'is happy if SRI and CORS provided' do
    file = "#{FIXTURES_DIR}/scripts/integrity_and_cors_provided.html"
    proofer = run_proofer(file, :file, check_sri: true)
    expect(proofer.failed_tests).to eq []
  end

  it 'does not check SRI/CORS for local scripts' do
    file = "#{FIXTURES_DIR}/scripts/local_script.html"
    proofer = run_proofer(file, :file, check_sri: true)
    expect(proofer.failed_tests).to eq []
  end
end
