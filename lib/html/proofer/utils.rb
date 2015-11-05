require 'nokogiri'

module HTML
  class Proofer
    module Utils
      STORAGE_DIR = File.join('tmp', '.htmlproofer')

      def pluralize(count, single, plural)
        "#{count} " << (count == 1 ? single : plural)
      end

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
