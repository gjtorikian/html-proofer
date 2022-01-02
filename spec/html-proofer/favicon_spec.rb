# frozen_string_literal: true

require 'spec_helper'

describe 'Favicons test' do
  it 'ignores for absent favicon by default' do
    absent = File.join(FIXTURES_DIR, 'favicon', 'favicon_absent.html')
    expect(run_proofer(absent, :file).failed_checks).to eq []
  end

  it 'fails for absent favicon' do
    absent = File.join(FIXTURES_DIR, 'favicon', 'favicon_absent.html')
    proofer = run_proofer(absent, :file, checks: ['Favicon'])
    expect(proofer.failed_checks.first.description).to match(/no favicon provided/)
  end

  it 'fails for absent favicon but present apple touch icon' do
    absent = File.join(FIXTURES_DIR, 'favicon', 'favicon_absent_apple.html')
    proofer = run_proofer(absent, :file, checks: ['Favicon'])
    expect(proofer.failed_checks.last.description).to match(/(no favicon provided)/)
  end

  it 'fails for broken internal favicon' do
    broken = File.join(FIXTURES_DIR, 'favicon', 'internal_favicon_broken.html')
    proofer = run_proofer(broken, :file, checks: ['Favicon'])
    expect(proofer.failed_checks.first.description).to match(/internal favicon asdadaskdalsdk.png/)
  end

  it 'fails for broken external favicon' do
    broken = File.join(FIXTURES_DIR, 'favicon', 'external_favicon_broken.html')
    proofer = run_proofer(broken, :file, checks: ['Favicon'])
    expect(proofer.failed_checks.first.description).to match(%r{External link https://www.github.com/asdadaskdalsdk.png})
  end

  it 'fails for ignored with ignore_urls' do
    ignored = File.join(FIXTURES_DIR, 'favicon', 'internal_favicon_broken.html')
    proofer = run_proofer(ignored, :file, checks: ['Favicon'], ignore_urls: [/asdadaskdalsdk/])
    expect(proofer.failed_checks.first.description).to match(/no favicon provided/)
  end

  it 'translates links via swap_urls' do
    translated_link = File.join(FIXTURES_DIR, 'favicon', 'internal_favicon_broken.html')
    proofer = run_proofer(translated_link, :file, checks: ['Favicon'], swap_urls: { /^asdadaskdalsdk.+/ => '../resources/gpl.png' })
    expect(proofer.failed_checks).to eq []
  end

  it 'passes for present favicon' do
    present = File.join(FIXTURES_DIR, 'favicon', 'favicon_present.html')
    proofer = run_proofer(present, :file, checks: ['Favicon'])
    expect(proofer.failed_checks).to eq []
  end

  it 'passes for present favicon with shortcut notation' do
    present = File.join(FIXTURES_DIR, 'favicon', 'favicon_present_shortcut.html')
    proofer = run_proofer(present, :file, checks: ['Favicon'])
    expect(proofer.failed_checks).to eq []
  end

  it 'fails for broken favicon with data-proofer-ignore' do
    broken_but_ignored = File.join(FIXTURES_DIR, 'favicon', 'favicon_broken_but_ignored.html')
    proofer = run_proofer(broken_but_ignored, :file, checks: ['Favicon'])
    expect(proofer.failed_checks.first.description).to match(/no favicon provided/)
  end

  it 'specifically ignores jekyll redirect_from template' do
    broken_but_ignored = File.join(FIXTURES_DIR, 'favicon', 'jekyll_redirect_from.html')
    proofer = run_proofer(broken_but_ignored, :file, checks: ['Favicon'])
    expect(proofer.failed_checks).to eq []
  end

  it 'ignores SRI/CORS requirements for favicons' do
    file = File.join(FIXTURES_DIR, 'favicon', 'cors_not_needed.html')
    proofer = run_proofer(file, :file, check_sri: true)
    expect(proofer.failed_checks).to eq []
  end
end
