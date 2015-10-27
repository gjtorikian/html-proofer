require 'spec_helper'

describe 'Cache test' do

  it 'knows how to write to cache' do
    stub_const('HTML::Proofer::Cache::FILENAME', "#{FIXTURES_DIR}/cache/.htmlproofer.log")
    delete_cache

    brokenLinkExternalFilepath = "#{FIXTURES_DIR}/links/brokenLinkExternal.html"
    run_proofer(brokenLinkExternalFilepath)

    log = read_cache
    expect(log.keys.length).to eq(2)
    statuses = log.values.map { |h| h['status'] }
    expect(statuses.count(200)).to eq(1)
    expect(statuses.count(0)).to eq(1)
  end

  it 'knows how to load a cache' do
    stub_const('HTML::Proofer::Cache::FILENAME', "#{FIXTURES_DIR}/cache/.simple_load.log")

    expect_any_instance_of(HTML::Proofer::Cache).to receive(:load).once

    brokenLinkExternalFilepath = "#{FIXTURES_DIR}/links/bad_external_links.html"
    run_proofer(brokenLinkExternalFilepath, { :cache => { :timeframe => '30d' } })
  end

  it 'fails on an invalid date' do
    file = "#{FIXTURES_DIR}/links/brokenLinkExternal.html"
    expect {
      run_proofer(file, { :cache => { :timeframe => '30x' } })
    }.to raise_error ArgumentError
  end

  it 'does not write file if timestamp is within date' do
    stub_const('HTML::Proofer::Cache::FILENAME', "#{FIXTURES_DIR}/cache/.within_date.log")

    # this is frozen to within 7 days of the log
    new_time = Time.local(2015, 10, 20, 12, 0, 0)
    Timecop.freeze(new_time)

    log = read_cache
    current_time = log.values.first['time']

    run_proofer(['www.github.com'], { :cache => { :timeframe => '30d' } })

    # note that the timestamp did not change
    log = read_cache
    new_time = log.values.first['time']
    expect(current_time).to eq(new_time)

    Timecop.return
  end

  it 'does write file if timestamp is not within date' do
    stub_const('HTML::Proofer::Cache::FILENAME', "#{FIXTURES_DIR}/cache/.not_within_date.log")

    # this is frozen to within 20 days after the log
    new_time = Time.local(2014, 10, 21, 12, 0, 0)
    Timecop.travel(new_time)

    # since the timestamp changed, we expect an add
    expect_any_instance_of(HTML::Proofer::Cache).to receive(:add)
    run_proofer(['www.github.com'], { :cache => { :timeframe => '4d' } })


    Timecop.return
  end
end
