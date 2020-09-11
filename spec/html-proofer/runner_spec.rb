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

      cassette_name = make_cassette_name("#{FIXTURES_DIR}/links/check_just_once.html", opts)
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
