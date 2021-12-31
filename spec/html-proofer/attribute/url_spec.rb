# frozen_string_literal: true

require 'spec_helper'

describe HTMLProofer::Attribute::Url do
  before(:each) do
    @runner = HTMLProofer::Runner.new('')
  end

  describe '#ignores_pattern_check' do
    it 'works for regex patterns' do
      @runner.options[:ignore_urls] = [%r{/assets/.*(js|css|png|svg)}]
      url = HTMLProofer::Attribute::Url.new(@runner, '/assets/main.js')
      expect(url.ignore?).to eq true
    end

    it 'works for string patterns' do
      @runner.options[:ignore_urls] = ['/assets/main.js']
      url = HTMLProofer::Attribute::Url.new(@runner, '/assets/main.js')
      expect(url.ignore?).to eq true
    end
  end
end
