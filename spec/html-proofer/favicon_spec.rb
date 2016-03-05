require 'spec_helper'

describe 'Favicons test' do
  it 'ignores for absent favicon by default' do
    absent = "#{FIXTURES_DIR}/favicon/favicon_absent.html"
    expect(run_proofer(absent, :file).failed_tests).to eq []
  end

  it 'fails for absent favicon' do
    absent = "#{FIXTURES_DIR}/favicon/favicon_absent.html"
    proofer = run_proofer(absent, :file, { :check_favicon => true })
    expect(proofer.failed_tests.first).to match(/no favicon specified/)
  end

  it 'fails for absent favicon but present apple touch icon' do
    absent = "#{FIXTURES_DIR}/favicon/favicon_absent_apple.html"
    proofer = run_proofer(absent, :file, { :check_favicon => true })
    # Travis gives a different error message here for some reason
    expect(proofer.failed_tests.last).to match(/(internally linking to gpl.png, which does not exist|no favicon specified)/)
  end

  it 'fails for broken favicon' do
    broken = "#{FIXTURES_DIR}/favicon/favicon_broken.html"
    proofer = run_proofer(broken, :file, { :check_favicon => true })
    expect(proofer.failed_tests.first).to match(/internally linking to asdadaskdalsdk.png/)
  end

  it 'fails for ignored with url_ignore' do
    ignored = "#{FIXTURES_DIR}/favicon/favicon_broken.html"
    proofer = run_proofer(ignored, :file, { :check_favicon => true, :url_ignore => [/asdadaskdalsdk/] })
    expect(proofer.failed_tests.first).to match(/no favicon specified/)
  end

  it 'translates links via url_swap' do
    translatedLink = "#{FIXTURES_DIR}/favicon/favicon_broken.html"
    proofer = run_proofer(translatedLink, :file, { :check_favicon => true, :url_swap => { /^asdadaskdalsdk.+/ => '../resources/gpl.png' } })
    expect(proofer.failed_tests).to eq []
  end

  it 'passes for present favicon' do
    present = "#{FIXTURES_DIR}/favicon/favicon_present.html"
    proofer = run_proofer(present, :file, { :check_favicon => true })
    expect(proofer.failed_tests).to eq []
  end

  it 'passes for present favicon with shortcut notation' do
    present = "#{FIXTURES_DIR}/favicon/favicon_present_shortcut.html"
    proofer =  run_proofer(present, :file, { :check_favicon => true })
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for broken favicon with data-proofer-ignore' do
    broken_but_ignored = "#{FIXTURES_DIR}/favicon/favicon_broken_but_ignored.html"
    proofer = run_proofer(broken_but_ignored, :file, { :check_favicon => true })
    expect(proofer.failed_tests.first).to match(/no favicon specified/)
  end

end
