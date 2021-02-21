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

  context 'options' do
    let(:response_fixture) { File.join(File.absolute_path(FIXTURES_DIR), 'links', 'broken_root_link_internal.html') }

    before(:each) do
      @default_opts = HTMLProofer::Middleware.options[:url_ignore]
    end

    after(:each) do
      HTMLProofer::Middleware.options[:url_ignore] = @default_opts
    end

    let(:middleware_with_ignore) do
      HTMLProofer::Middleware.options[:url_ignore] = [/broken/]
      HTMLProofer::Middleware.new(app)
    end
    let(:middleware_with_no_ignore) do
      HTMLProofer::Middleware.options[:url_ignore] = nil
      HTMLProofer::Middleware.new(app)
    end

    let(:subject) { middleware.call(request) }
    let(:subject_with_ignore) { middleware_with_ignore.call(request) }
    let(:subject_with_no_ignore) { middleware_with_no_ignore.call(request) }
    context 'internal files' do
      it 'does not raise an error with default options set' do
        subject
      end

      it 'does not raise an error with options explicitly set' do
        subject_with_ignore
      end

      it 'does raise an error with options removed' do
        expect do
          subject_with_no_ignore
        end.to raise_error(HTMLProofer::Middleware::InvalidHtmlError)
      end
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
