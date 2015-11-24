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

        Nokogiri::HTML(clean_content(content))
      end
      module_function :create_nokogiri

      def swap(href, replacement)
        replacement.each do |link, replace|
          href = href.gsub(link, replace)
        end
        href
      end
      module_function :swap

      # address a problem with Nokogiri's parsing URL entities
      # problem from http://git.io/vBYU1
      # solution from http://git.io/vBYUi
      def clean_content(string)
        matches = string.scan(%r{<url>http(?:s)?://([^<]+)<\/url>}i) +
                  string.scan(%r{"http(?:s)?://([^"]+)"}i) +
                  string.scan(%r{\shttp(?:s)?://([^\s]+)\s}i) +
                  string.scan(%r{window.open\(['"]http(?:s)?://([^\s]+)\s}i)

        matches.flatten.each do |url|
          escaped_url = url.gsub(/&(?!amp;)/, '&amp;')
          escaped_url = escaped_url.gsub(%r{/}, '&#47;')
          string.gsub!(url, escaped_url)
        end
        string
      end
      module_function :clean_content
    end
  end
end
