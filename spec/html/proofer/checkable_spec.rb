require 'spec_helper'

describe HTML::Proofer::Checkable do
  describe '#initialize' do
    it 'accepts xmlns attribute' do
      nokogiri = Nokogiri::HTML '<a xmlns:cc="http://creativecommons.org/ns#">Creative Commons</a>'
      checkable = HTML::Proofer::Checkable.new nokogiri.css('a').first, nil
      expect(checkable.instance_variable_get(:@xmlns_cc)).to eq 'http://creativecommons.org/ns#'
    end
  end
  describe '#ignores_pattern_check' do
    it 'works for regex patterns' do
      nokogiri = Nokogiri::HTML '<script src=/assets/main.js></script>'
      checkable = HTML::Proofer::Checkable.new nokogiri.css('script').first, nil
      expect(checkable.ignores_pattern_check([/\/assets\/.*(js|css|png|svg)/])).to eq true
    end
    it 'works for string patterns' do
      nokogiri = Nokogiri::HTML '<script src=/assets/main.js></script>'
      checkable = HTML::Proofer::Checkable.new nokogiri.css('script').first, nil
      expect(checkable.ignores_pattern_check(['/assets/main.js'])).to eq true
    end
  end
  describe '#url' do
    it 'works for src attributes' do
      nokogiri = Nokogiri::HTML '<img src=image.png />'
      checkable = HTML::Proofer::Checkable.new nokogiri.css('img').first, nil
      expect(checkable.url).to eq 'image.png'
    end
  end
end
