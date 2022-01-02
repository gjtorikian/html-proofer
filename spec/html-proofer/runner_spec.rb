# frozen_string_literal: true

require 'spec_helper'

describe HTMLProofer::Runner do
  describe '#before_request' do
    it 'sends authorization header to github.com' do
      opts = {}
      url = 'https://github.com'
      proofer = make_proofer([url], :links, opts)
      request = nil
      auth = 'Bearer <TOKEN>'
      proofer.before_request do |r|
        r.options[:headers]['Authorization'] = auth if r.base_url == url
        request = r
      end

      cassette_name = make_cassette_name(File.join(FIXTURES_DIR, 'links', 'check_just_once.html'), opts)
      VCR.use_cassette(cassette_name, record: :new_episodes) do
        capture_stderr { proofer.run }
        proofer
      end

      expect(request).to respond_to(:options)
      expect(request.options).to include(:headers)
      expect(request.options[:headers]).to include('Authorization' => auth)
    end

    it 'plays nice with cache' do
      cache_file_name = '.runner.json'
      storage_dir = File.join(FIXTURES_DIR, 'cache', 'version_2')
      cache_location = File.join(storage_dir, cache_file_name)

      File.delete(cache_location) if File.exist?(cache_location)

      opts = {
        cache: { timeframe: '1d', cache_file: cache_file_name, storage_dir: storage_dir }
      }
      dir = File.join(FIXTURES_DIR, 'links', '_site')
      proofer = make_proofer(dir, :directory, opts)
      request = nil
      auth = 'Bearer <TOKEN>'
      proofer.before_request do |r|
        r.options[:headers]['Authorization'] = auth
        request = r
      end

      cassette_name = make_cassette_name(dir, opts)
      VCR.use_cassette(cassette_name, record: :new_episodes) do
        capture_stderr { proofer.run }
        proofer
      end

      expect(request).to respond_to(:options)
      expect(request.options).to include(:headers)
      expect(request.options[:headers]).to include('Authorization' => auth)
    end
  end
end
