require 'spec_helper'

describe HTML::Proofer::Checkable do
  describe '#initialize' do
    it 'accepts xmlns attribute' do
      nokogiri = Nokogiri::HTML '<a xmlns:cc="http://creativecommons.org/ns#">Creative Commons</a>'
      checkable = HTML::Proofer::Checkable.new nokogiri.css('a').first, nil
      expect(checkable.instance_variable_get(:@xmlns_cc)).to eq 'http://creativecommons.org/ns#'
    end
  end
end
