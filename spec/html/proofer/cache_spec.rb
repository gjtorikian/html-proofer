require 'spec_helper'

describe 'Cache test' do
  it 'ignores an invalid tag by default' do
    brokenLinkExternalFilepath = "#{FIXTURES_DIR}/links/brokenLinkExternal.html"
    proofer = run_proofer(brokenLinkExternalFilepath)
    expect(proofer.failed_tests.first).to match(/failed: 0/)

    proofer = run_proofer(brokenLinkExternalFilepath, { :cache => { :timeframe => '30d' } })
    expect(proofer.failed_tests.first).to match(/failed: 0/)
  end

  it 'fails on an invalid date' do
    file = "#{FIXTURES_DIR}/links/brokenLinkExternal.html"
    expect {
      run_proofer(file, { :cache => { :timeframe => '30x' } })
    }.to raise_error ArgumentError
  end

  it 'does not write file if timestamp is within date' do

  end
end
