# frozen_string_literal: true

require 'spec_helper'

describe 'Scripts test' do
  it 'fails for broken external src' do
    file = File.join(FIXTURES_DIR, 'scripts', 'script_broken_external.html')
    proofer = run_proofer(file, :file)
    expect(proofer.failed_checks.first.description).to match(/failed with something very wrong/)
  end

  it 'works for valid internal src' do
    file = File.join(FIXTURES_DIR, 'scripts', 'script_valid_internal.html')
    proofer = run_proofer(file, :file)
    expect(proofer.failed_checks).to eq []
  end

  it 'fails for missing internal src' do
    file = File.join(FIXTURES_DIR, 'scripts', 'script_missing_internal.html')
    proofer = run_proofer(file, :file)
    expect(proofer.failed_checks.length).to eq 1
    expect(proofer.failed_checks.first.description).to include('internal script reference doesnotexist.js does not exist')
  end

  it 'works for present content' do
    file = File.join(FIXTURES_DIR, 'scripts', 'script_content.html')
    proofer = run_proofer(file, :file)
    expect(proofer.failed_checks).to eq []
  end

  it 'fails for absent content' do
    file = File.join(FIXTURES_DIR, 'scripts', 'script_content_absent.html')
    proofer = run_proofer(file, :file)
    expect(proofer.failed_checks.first.description).to match(/script is empty and has no src attribute/)
  end

  it 'works for broken script within pre' do
    script_pre = File.join(FIXTURES_DIR, 'scripts', 'script_in_pre.html')
    proofer = run_proofer(script_pre, :file)
    expect(proofer.failed_checks).to eq []
  end

  it 'ignores links via ignore_urls' do
    ignorable_links = File.join(FIXTURES_DIR, 'scripts', 'ignorable_links_via_options.html')
    proofer = run_proofer(ignorable_links, :file, ignore_urls: [%r{/assets/.*(js|css|png|svg)}])
    expect(proofer.failed_checks).to eq []
  end

  it 'translates src via swap_urls' do
    file = File.join(FIXTURES_DIR, 'scripts', 'script_abs_url.html')
    proofer = run_proofer(file, :file, swap_urls: { %r{^http://example.com} => '' })
    expect(proofer.failed_checks).to eq []
  end

  it 'is unhappy if SRI and CORS not provided' do
    file = File.join(FIXTURES_DIR, 'scripts', 'integrity_and_cors_not_provided.html')
    proofer = run_proofer(file, :file, check_sri: true)
    expect(proofer.failed_checks.first.description).to match(/SRI and CORS not provided/)
  end

  it 'is unhappy if SRI not provided' do
    file = File.join(FIXTURES_DIR, 'scripts', 'cors_not_provided.html')
    proofer = run_proofer(file, :file, check_sri: true)
    expect(proofer.failed_checks.first.description).to match(/CORS not provided/)
  end

  it 'is unhappy if CORS not provided' do
    file = File.join(FIXTURES_DIR, 'scripts', 'integrity_not_provided.html')
    proofer = run_proofer(file, :file, check_sri: true)
    expect(proofer.failed_checks.first.description).to match(/Integrity is missing/)
  end

  it 'is happy if SRI and CORS provided' do
    file = File.join(FIXTURES_DIR, 'scripts', 'integrity_and_cors_provided.html')
    proofer = run_proofer(file, :file, check_sri: true)
    expect(proofer.failed_checks).to eq []
  end

  it 'does not check SRI/CORS for local scripts' do
    file = File.join(FIXTURES_DIR, 'scripts', 'local_script.html')
    proofer = run_proofer(file, :file, check_sri: true)
    expect(proofer.failed_checks).to eq []
  end
end
