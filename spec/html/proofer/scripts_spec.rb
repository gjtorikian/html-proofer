require 'spec_helper'

describe 'Scripts test' do

  it 'fails for broken external src' do
    file = "#{FIXTURES_DIR}/scripts/script_broken_external.html"
    proofer = make_proofer(file)
    expect(proofer.failed_tests.first).to match(%r{External link http://www.asdo3IRJ395295jsingrkrg4.com/asdo3IRJ.js failed: 0 Couldn't resolve host name})
  end

  it 'works for valid internal src' do
    file = "#{FIXTURES_DIR}/scripts/script_valid_internal.html"
    proofer = make_proofer(file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for missing internal src' do
    file = "#{FIXTURES_DIR}/scripts/script_missing_internal.html"
    proofer = make_proofer(file)
    expect(proofer.failed_tests.first).to match(/doesnotexist.js does not exist/)
  end

  it 'works for present content' do
    file = "#{FIXTURES_DIR}/scripts/script_content.html"
    proofer = make_proofer(file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for absent content' do
    file = "#{FIXTURES_DIR}/scripts/script_content_absent.html"
    proofer = make_proofer(file)
    expect(proofer.failed_tests.first).to match(/script is empty and has no src attribute/)
  end

  it 'works for broken script within pre' do
    script_pre = "#{FIXTURES_DIR}/scripts/script_in_pre.html"
    proofer = make_proofer(script_pre)
    expect(proofer.failed_tests).to eq []
  end

end
