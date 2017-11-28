require 'nokogiri'

module HTMLProofer
  module Utils
    def pluralize(count, single, plural)
      "#{count} " << (count == 1 ? single : plural)
    end

    def create_nokogiri(path)
      content = if File.exist? path
                  File.open(path).read
                else
                  path
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
      string.gsub(%r{https?://([^>]+)}i) do |url|
        url.gsub(/&(?!amp;)/, '&amp;')
      end
    end
    module_function :clean_content
  end
end
