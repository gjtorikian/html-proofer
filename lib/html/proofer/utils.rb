require 'nokogiri'

module HTML
  module Utils
    extend self

    def create_nokogiri(path)
      content = File.open(path).read
      Nokogiri::HTML(content)
    end
  end
end
