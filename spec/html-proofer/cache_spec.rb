# frozen_string_literal: true

require 'spec_helper'

describe 'Cache test' do
  let(:cache_fixture_dir) { File.join(FIXTURES_DIR, 'cache') }

  let(:default_cache_options) { { storage_dir: cache_fixture_dir } }

  let(:file_runner) { HTMLProofer.check_file(test_file, runner_options) }
  let(:link_runner) { HTMLProofer.check_links(links, runner_options) }

  def read_cache(cache_filename)
    JSON.parse File.read(File.join(cache_fixture_dir, cache_filename))
  end

  context 'time parser' do
    let(:links) { ['www.github.com'] }
    let(:runner_options) { default_cache_options }

    it 'understands months' do
      now_time = Time.local(2019, 9, 6, 12, 0, 0)
      Timecop.freeze(now_time) do
        cache = HTMLProofer::Cache.new(link_runner, timeframe: '2M')

        check_time = Time.local(2019, 8, 6, 12, 0, 0).to_s

        expect(cache.within_timeframe?(check_time)).to be true

        check_time = Time.local(2019, 5, 6, 12, 0, 0).to_s

        expect(cache.within_timeframe?(check_time)).to be false
      end
    end

    it 'understands days' do
      now_time = Time.local(2019, 9, 6, 12, 0, 0)
      Timecop.freeze(now_time) do
        cache = HTMLProofer::Cache.new(link_runner, timeframe: '2d')

        check_time = Time.local(2019, 9, 5, 12, 0, 0).to_s

        expect(cache.within_timeframe?(check_time)).to be true

        check_time = Time.local(2019, 5, 6, 12, 0, 0).to_s

        expect(cache.within_timeframe?(check_time)).to be false
      end
    end

    it 'understands weeks' do
      now_time = Time.local(2019, 9, 6, 12, 0, 0)
      Timecop.freeze(now_time) do
        cache = HTMLProofer::Cache.new(link_runner, timeframe: '2w')

        check_time = Time.local(2019, 8, 30, 12, 0, 0).to_s

        expect(cache.within_timeframe?(check_time)).to be true

        check_time = Time.local(2019, 5, 6, 12, 0, 0).to_s

        expect(cache.within_timeframe?(check_time)).to be false
      end
    end

    it 'understands hours' do
      now_time = Time.local(2019, 9, 6, 12, 0, 0)
      Timecop.freeze(now_time) do
        cache = HTMLProofer::Cache.new(link_runner, timeframe: '3h')

        check_time = Time.local(2019, 9, 6, 9, 0, 0).to_s

        expect(cache.within_timeframe?(check_time)).to be true

        check_time = Time.local(2019, 5, 6, 12, 0, 0).to_s

        expect(cache.within_timeframe?(check_time)).to be false
      end
    end

    it 'fails on an invalid date' do
      file = File.join(FIXTURES_DIR, 'links', 'broken_link_external.html')
      expect do
        run_proofer(file, :file, cache: { timeframe: '30x' }.merge(default_cache_options))
      end.to raise_error ArgumentError
    end
  end

  context 'version 2' do
    it 'knows how to write to cache' do
      test_file = File.join(cache_fixture_dir, 'internal_and_external_example.html')
      cache_filename = File.join('version_2', '.htmlproofer_test.json')
      cache_filepath = File.join(cache_fixture_dir, cache_filename)

      File.delete(cache_filepath) if File.exist?(cache_filepath)

      allow(HTMLProofer::Cache).to receive(:write).once
      run_proofer(test_file, :file, cache: { timeframe: '30d', cache_file: cache_filename }.merge(default_cache_options))

      log = read_cache(cache_filename)
      expect(log.keys.length).to eq(3)

      # should look like:
      # {
      #   "version": xxx,
      #   "internal": {
      #     "/": {
      #       "time": "2015-10-20 12:00:00 -0700",
      #       "found": false,
      #       "metadata": [...]
      #     }
      #   },
      #   "external": {
      #     "www.github.com": {
      #       "time": "2015-10-20 12:00:00 -0700",
      #       "status": 200,
      #       "message": "OK",
      #       "metadata": [...]
      #     }
      #   }
      # }

      expect(log['version']).to eq(2)
      external_urls = log['external']
      external_url = external_urls['https://github.com/gjtorikian/html-proofer']
      expect(external_url['status']).to eq(200)
      expect(external_url['metadata'].first['line']).to eq(7)

      internal_urls = log['internal']
      internal_url = internal_urls['/somewhere.html']
      expect(internal_url['metadata'].first['line']).to eq(11)
      expect(internal_url['metadata'].first['found']).to eq(false)

      File.delete(cache_filepath) if File.exist?(cache_filepath)
    end

    context 'external links' do
      context 'dates' do
        let(:cache_filename) { File.join('version_2', '.within_date_external.json') }
        it 'does not write file if timestamp is within date' do
          # this is frozen to within 7 days of the log
          new_time = Time.local(2015, 10, 27, 12, 0, 0)
          Timecop.freeze(new_time) do
            expect_any_instance_of(HTMLProofer::Cache).to receive(:write)

            # we expect no add since we are within the timeframe
            expect_any_instance_of(HTMLProofer::Cache).to_not receive(:add_external)

            run_proofer(['www.github.com'], :links, cache: { timeframe: '30d', cache_file: cache_filename }.merge(default_cache_options))
          end
        end

        it 'does write file if timestamp is not within date' do
          new_time = Time.local(2021, 10, 27, 12, 0, 0)
          Timecop.freeze(new_time) do
            expect_any_instance_of(HTMLProofer::Cache).to receive(:write)

            # we expect an add since we are mocking outside the timeframe
            expect_any_instance_of(HTMLProofer::Cache).to receive(:add_external).with('www.github.com', [], 200, 'OK')

            run_proofer(['www.github.com'], :links, cache: { timeframe: '4d', cache_file: cache_filename }.merge(default_cache_options))
          end
        end
      end

      context 'new external url added' do
        let(:cache_filename) { File.join('version_2', '.new_external_url.json') }
        it 'does write file if a new URL is added' do
          # this is frozen to within 7 days of the log
          new_time = Time.local(2015, 10, 20, 12, 0, 0)
          Timecop.freeze(new_time) do
            expect_any_instance_of(HTMLProofer::Cache).to receive(:write)
            # we expect one new link to be added, but github.com can stay...
            expect_any_instance_of(HTMLProofer::Cache).to receive(:add_external).with('www.google.com', [], 200, 'OK')

            # ...because it's within the 30d time frame
            run_proofer(['www.github.com', 'www.google.com'], :links, cache: { timeframe: '30d', cache_file: cache_filename }.merge(default_cache_options))
          end
        end
      end
    end

    context 'internal links' do
      context 'dates' do
        let(:cache_filename) { File.join('version_2', '.within_date_internal.json') }
        let(:test_file) { File.join(FIXTURES_DIR, 'links', 'root_link', 'root_link.html') }

        it 'does not write file if timestamp is within date' do
          # this is frozen to within 7 days of the log
          new_time = Time.local(2015, 10, 27, 12, 0, 0)
          Timecop.freeze(new_time) do
            expect_any_instance_of(HTMLProofer::Cache).to receive(:write)

            # we expect no add since we are within the timeframe
            expect_any_instance_of(HTMLProofer::Cache).to_not receive(:add_internal)

            run_proofer(test_file, :file, disable_external: true, cache: { timeframe: '30d', cache_file: cache_filename }.merge(default_cache_options))
          end
        end

        it 'does write file if timestamp is not within date' do
          # this is frozen to within 7 days of the log
          new_time = Time.local(2015, 10, 27, 12, 0, 0)
          Timecop.freeze(new_time) do
            expect_any_instance_of(HTMLProofer::Cache).to receive(:write)

            # we expect an add since we are mocking outside the timeframe
            expect_any_instance_of(HTMLProofer::Cache).to receive(:add_internal).with('/', { :base_url => '', :found => false, :line => 11, :source => 'spec/html-proofer/fixtures/cache/internal_and_external_example.html' }, false)

            run_proofer(test_file, :file, disable_external: true, cache: { timeframe: '4d', cache_file: cache_filename }.merge(default_cache_options))
          end
        end
      end

      context 'new internal url added' do
        let(:cache_filename) { File.join('version_2', '.new_internal_url.json') }
        let(:cache_filepath) { File.join(cache_fixture_dir, 'version_2', '.new_internal_url.json') }
        # this is frozen to within 30 days of the log
        let(:new_time) { Time.local(2015, 10, 20, 12, 0, 0) }

        it 'does write file if a new relative URL 200 is added' do
          Timecop.freeze(new_time) do
            root_link = File.join(FIXTURES_DIR, 'links', 'root_link', 'root_link_with_another_link.html')

            expect_any_instance_of(HTMLProofer::Cache).to receive(:add_internal).once.with('/', { :base_url => '', current_path: root_link, :line => 5, :source => root_link }, true).and_call_original

            expect_any_instance_of(HTMLProofer::Cache).to receive(:write).once

            # we expect one new link to be added because it's within the 30d time frame
            run_proofer(root_link, :file, disable_external: true, cache: { timeframe: '30d', cache_file: cache_filename }.merge(default_cache_options))
          end
        end

        it 'does write file if a new relative URL 404 is added' do
          Timecop.freeze(new_time) do
            expect_any_instance_of(HTMLProofer::Cache).to receive(:write)
            root_link = File.join(FIXTURES_DIR, 'links', 'broken_internal_link.html')
            expect_any_instance_of(HTMLProofer::Cache).to receive(:add_internal).once.with('#noHash', { :base_url => '', :current_path => 'spec/html-proofer/fixtures/links/broken_internal_link.html', :line => 5, :source => 'spec/html-proofer/fixtures/links/broken_internal_link.html' }, false)

            # we expect one new link to be added because it's within the 30d time frame
            run_proofer(root_link, :file, disable_external: true, cache: { timeframe: '30d', cache_file: cache_filename }.merge(default_cache_options))
          end
        end

        it 'does writes file once if a new relative URL 404 hash is detected multiple times' do
          Timecop.freeze(new_time) do
            expect_any_instance_of(HTMLProofer::Cache).to receive(:write)
            root_link = File.join(FIXTURES_DIR, 'links', 'broken_internal_hashes')
            expect_any_instance_of(HTMLProofer::Cache).to receive(:add_internal).once

            # we expect one new link to be added because it's within the 30d time frame
            run_proofer(root_link, :directory, disable_external: true, cache: { timeframe: '30d', cache_file: cache_filename }.merge(default_cache_options))
          end
        end
      end
    end

    context 'rechecking failures' do
      it 'does recheck failures, regardless of cache' do
        cache_filename = File.join('version_2', '.recheck_failure.json')

        expect_any_instance_of(HTMLProofer::Cache).to receive(:write)

        # we expect the same link to be re-added, even though we are within the time frame,
        # because `foofoofoo.biz` was a failure
        expect_any_instance_of(HTMLProofer::Cache).to receive(:add_external)

        run_proofer(['http://www.foofoofoo.biz'], :links, cache: { timeframe: '30d', cache_file: cache_filename }.merge(default_cache_options))
      end

      it 'does recheck failures, regardless of external-only cache' do
        cache_filename = File.join('version_2', '.recheck_external_failure.json')
        cache_filepath = File.join(cache_fixture_dir, cache_filename)

        file = File.join(FIXTURES_DIR, 'cache', 'external_example.html')

        File.delete(cache_filepath) if File.exist?(cache_filepath)

        run_proofer(file, :file, cache: { timeframe: '1d', cache_file: cache_filename }.merge(default_cache_options))

        cache = read_cache(cache_filename)
        external_links = cache['external']
        expect(external_links.keys.first).to eq('https://github.com/gjtorikian/html-proofer')

        run_proofer(file, :file, cache: { timeframe: '1d', cache_file: cache_filename }.merge(default_cache_options))

        cache = read_cache(cache_filename)
        external_links = cache['external']
        expect(external_links.keys.first).to eq('https://github.com/gjtorikian/html-proofer')
      end

      it 'does recheck failures, regardless of external and internal cache' do
        cache_filename = File.join('version_2', '.internal_and_external.json')
        cache_location = File.join(cache_fixture_dir, cache_filename)

        file = File.join(FIXTURES_DIR, 'cache', 'internal_and_external_example.html')

        File.delete(cache_location) if File.exist?(cache_location)

        run_proofer(file, :file, cache: { timeframe: '1d', cache_file: cache_filename }.merge(default_cache_options))

        cache = read_cache(cache_filename)
        external_links = cache['external']
        expect(external_links.keys.first).to eq('https://github.com/gjtorikian/html-proofer')
        internal_links = cache['internal']
        expect(internal_links.keys.first).to eq('/somewhere.html')

        run_proofer(file, :file, cache: { timeframe: '1d', cache_file: cache_filename }.merge(default_cache_options))

        cache = read_cache(cache_filename)
        external_links = cache['external']
        expect(external_links.keys.first).to eq('https://github.com/gjtorikian/html-proofer')
        internal_links = cache['internal']
        expect(internal_links.keys.first).to eq('/somewhere.html')
      end
    end

    context 'removing links' do
      it 'removes external links that no longer exist' do
        test_file = File.join(FIXTURES_DIR, 'cache', 'external_example.html')
        cache_filename = File.join('version_2', '.removed_link.json')
        cache_location = File.join(cache_fixture_dir, cache_filename)

        File.delete(cache_location) if File.exist?(cache_location)

        run_proofer(test_file, :file, cache: { timeframe: '1d', cache_file: cache_filename }.merge(default_cache_options))

        cache = read_cache(cache_filename)
        external_links = cache['external']
        expect(external_links.keys.first).to eq('https://github.com/gjtorikian/html-proofer')

        run_proofer(File.join(FIXTURES_DIR, 'cache', 'some_link.html'), :file, cache: { timeframe: '1d', cache_file: cache_filename }.merge(default_cache_options))

        cache = read_cache(cache_filename)
        external_links = cache['external']
        expect(external_links.keys.first).to eq('https://github.com/gjtorikian')
      end
    end
  end
end
