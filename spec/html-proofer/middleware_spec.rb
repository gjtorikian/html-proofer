# frozen_string_literal: true

require 'spec_helper'

describe 'Middleware test' do
  let(:request) { { 'REQUEST_METHOD' => 'GET' } }
  let(:response) { File.open(response_fixture) }
  let(:app) { proc { |*_args| [200, {}, response] } }
  let(:middleware) { HTMLProofer::Middleware.new(app) }
  subject { middleware.call(request) }

  context 'with invalid HTML' do
    let(:response_fixture) { File.join(FIXTURES_DIR, 'html', 'missing_closing_quotes.html') }
    it 'raises an error' do
      expect do
        subject
      end.to raise_error(HTMLProofer::Middleware::InvalidHtmlError)
    end
  end

  context 'with valid HTML' do
    let(:response_fixture) { File.join(FIXTURES_DIR, 'html', 'html5_tags.html') }
    it 'does not raise an error' do
      subject
    end
  end

  context 'with non-HTML content' do
    let(:response_fixture) { File.join(FIXTURES_DIR, 'images', 'gpl.png') }
    it 'does not raise an error' do
      subject
    end
  end

  context 'proofer-ignore' do
    let(:skip_request) { { 'REQUEST_METHOD' => 'GET', 'QUERY_STRING' => 'proofer-ignore' } }
    let(:subject) { middleware.call(skip_request) }
    let(:response_fixture) { File.join(FIXTURES_DIR, 'html', 'missing_closing_quotes.html') }
    it 'does not raise an error' do
      subject
    end
  end
end
