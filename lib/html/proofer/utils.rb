require 'nokogiri'

module HTML
  module Utils
    extend self

    def create_nokogiri(path)
      if File.exist? path
        content = File.open(path).read
      else
        content = path
      end

      Nokogiri::HTML(content)
    end
  end
end
