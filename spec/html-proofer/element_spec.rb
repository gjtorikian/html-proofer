# frozen_string_literal: true

require 'spec_helper'

describe HTMLProofer::Element do
  before(:each) do
    @check = HTMLProofer::Check.new('', '', Nokogiri::HTML5(''), nil, nil, HTMLProofer::Configuration::PROOFER_DEFAULTS)
  end

  describe '#initialize' do
    it 'accepts the xmlns attribute' do
      nokogiri = Nokogiri::HTML5('<a xmlns:cc="http://creativecommons.org/ns#">Creative Commons</a>')
      checkable = HTMLProofer::Element.new(nokogiri.css('a').first, @check, nil)
      expect(checkable.instance_variable_get(:@xmlns_cc)).to eq 'http://creativecommons.org/ns#'
    end

    it 'assignes the text node' do
      nokogiri = Nokogiri::HTML5('<p>One')
      checkable = HTMLProofer::Element.new(nokogiri.css('p').first, @check, nil)
      expect(checkable.instance_variable_get(:@text)).to eq 'One'
    end

    it 'accepts the content attribute' do
      nokogiri = Nokogiri::HTML5('<meta name="twitter:card" content="summary">')
      checkable = HTMLProofer::Element.new(nokogiri.css('meta').first, @check, nil)
      expect(checkable.instance_variable_get(:@content)).to eq 'summary'
    end
  end

  describe '#ignores_pattern_check' do
    it 'works for regex patterns' do
      nokogiri = Nokogiri::HTML5('<script src=/assets/main.js></script>')
      checkable = HTMLProofer::Element.new(nokogiri.css('script').first, @check, nil)
      expect(checkable.ignores_pattern_check([%r{/assets/.*(js|css|png|svg)}])).to eq true
    end

    it 'works for string patterns' do
      nokogiri = Nokogiri::HTML5('<script src=/assets/main.js></script>')
      checkable = HTMLProofer::Element.new(nokogiri.css('script').first, @check, nil)
      expect(checkable.ignores_pattern_check(['/assets/main.js'])).to eq true
    end
  end

  describe '#url' do
    it 'works for src attributes' do
      nokogiri = Nokogiri::HTML5('<img src=image.png />')
      checkable = HTMLProofer::Element.new(nokogiri.css('img').first, @check, nil)
      expect(checkable.url).to eq 'image.png'
    end
  end

  describe '#ignore' do
    it 'works for twitter cards' do
      nokogiri = Nokogiri::HTML5('<meta name="twitter:url" data-proofer-ignore content="http://example.com/soon-to-be-published-url">')
      checkable = HTMLProofer::Element.new(nokogiri.css('meta').first, @check, nil)
      expect(checkable.ignore?).to eq true
    end
  end

  describe 'ivar setting' do
    it 'does not explode if given a bad attribute' do
      broken_attribute = "#{FIXTURES_DIR}/html/invalid_attribute.html"
      proofer = run_proofer(broken_attribute, :file)
      expect(proofer.failed_tests.length).to eq 0
    end
  end
end
