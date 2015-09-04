require 'nokogiri'

module HTML
  class Proofer
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

      def swap(href, replacement)
        replacement.each do |link, replace|
          href = href.gsub(link, replace)
        end
        href
      end
      module_function :swap
    end
  end
end
