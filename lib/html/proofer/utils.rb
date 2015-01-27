require 'nokogiri'

module HTML
  module Utils
    def create_nokogiri(path)
      if File.exist? path
        content = File.open(path).read
      else
        content = path
      end

      Nokogiri::HTML(content)
    end
    module_function :create_nokogiri
  end
end
