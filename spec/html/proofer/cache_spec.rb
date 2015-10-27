require 'spec_helper'

describe 'Cache test' do

  it 'knows how to write to cache' do
    delete_cache

    expect_any_instance_of(HTML::Proofer::Cache).to receive(:add).twice
    expect_any_instance_of(HTML::Proofer::Cache).to_not receive(:load)
    brokenLinkExternalFilepath = "#{FIXTURES_DIR}/links/brokenLinkExternal.html"
    proofer = run_proofer(brokenLinkExternalFilepath)
    expect(proofer.failed_tests.first).to match(/failed: 0/)
  end

  it 'knows how to load a cache' do
    write_cache

    expect_any_instance_of(HTML::Proofer::Cache).to_not receive(:add)
    expect_any_instance_of(HTML::Proofer::Cache).to receive(:load).once
    brokenLinkExternalFilepath = "#{FIXTURES_DIR}/links/brokenLinkExternal.html"
    proofer = run_proofer(brokenLinkExternalFilepath, { :cache => { :timeframe => '30d' } })
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
