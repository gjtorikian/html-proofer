require 'spec_helper'

describe 'Cache test' do
  it 'ignores an invalid tag by default' do
    brokenLinkExternalFilepath = "#{FIXTURES_DIR}/links/brokenLinkExternal.html"
    proofer = run_proofer(brokenLinkExternalFilepath)
    expect(proofer.failed_tests.first).to match(/failed: 0/)

    run_proofer(brokenLinkExternalFilepath, { :cache => { :timeframe => '30d' } })
  end


end
