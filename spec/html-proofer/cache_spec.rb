require 'spec_helper'

describe 'Cache test' do

  it 'knows how to write to cache' do
    stub_const('HTMLProofer::Cache::CACHE_LOG', "#{FIXTURES_DIR}/cache/.htmlproofer.log")

    brokenLinkExternalFilepath = "#{FIXTURES_DIR}/links/brokenLinkExternal.html"
    expect_any_instance_of(HTMLProofer::Cache).to receive(:write)
    run_proofer(brokenLinkExternalFilepath, :file, :cache => { :timeframe => '30d' })

    log = read_cache
    expect(log.keys.length).to eq(2)
    statuses = log.values.map { |h| h['status'] }
    expect(statuses.count(200)).to eq(1)
    expect(statuses.count(0)).to eq(1)
  end

  it 'fails on an invalid date' do
    file = "#{FIXTURES_DIR}/links/brokenLinkExternal.html"
    expect {
      run_proofer(file, :file, { :cache => { :timeframe => '30x' } })
    }.to raise_error ArgumentError
  end

  it 'does not write file if timestamp is within date' do
    stub_const('HTMLProofer::Cache::CACHE_LOG', "#{FIXTURES_DIR}/cache/.within_date.log")

    # this is frozen to within 7 days of the log
    new_time = Time.local(2015, 10, 20, 12, 0, 0)
    Timecop.freeze(new_time)

    log = read_cache
    current_time = log.values.first['time']

    expect_any_instance_of(HTMLProofer::Cache).to receive(:write)
    run_proofer(['www.github.com'], :links, { :cache => { :timeframe => '30d' } })

    # note that the timestamp did not change
    log = read_cache
    new_time = log.values.first['time']
    expect(current_time).to eq(new_time)

    Timecop.return
  end

  it 'does write file if timestamp is not within date' do
    stub_const('HTMLProofer::Cache::CACHE_LOG', "#{FIXTURES_DIR}/cache/.not_within_date.log")

    # this is frozen to within 20 days after the log
    new_time = Time.local(2014, 10, 21, 12, 0, 0)
    Timecop.travel(new_time)

    # since the timestamp changed, we expect an add
    expect_any_instance_of(HTMLProofer::Cache).to receive(:add)
    run_proofer(['www.github.com'], :links, { :cache => { :timeframe => '4d' } })

    Timecop.return
  end

  it 'does write file if a new URL is added' do
    stub_const('HTMLProofer::Cache::CACHE_LOG', "#{FIXTURES_DIR}/cache/.new_url.log")

    # this is frozen to within 7 days of the log
    new_time = Time.local(2015, 10, 20, 12, 0, 0)
    Timecop.freeze(new_time)

    expect_any_instance_of(HTMLProofer::Cache).to receive(:write)
    # we expect a new link to be added, but github.com can stay...
    expect_any_instance_of(HTMLProofer::Cache).to receive(:add).with('www.google.com', nil, 200)

    # ...because it's within the 30d time frame
    run_proofer(['www.github.com', 'www.google.com'], :links, { :cache => { :timeframe => '30d' } })

    Timecop.return
  end

  it 'does recheck failures, regardless of cache' do
    stub_const('HTMLProofer::Cache::CACHE_LOG', "#{FIXTURES_DIR}/cache/.recheck_failure.log")

    # this is frozen to within 7 days of the log
    new_time = Time.local(2015, 10, 20, 12, 0, 0)
    Timecop.freeze(new_time)

    expect_any_instance_of(HTMLProofer::Cache).to receive(:write)
    # we expect the same link to be readded...
    expect_any_instance_of(HTMLProofer::Cache).to receive(:add)

    # ...even though we are within the 30d time frame, because it's a failure
    run_proofer(['http://www.foofoofoo.biz'], :links, { :cache => { :timeframe => '30d' } })

    Timecop.return
  end
end
