# frozen_string_literal: true

require 'nokogumbo'

module HTMLProofer
  module Utils
    def pluralize(count, single, plural)
      "#{count} #{(count == 1 ? single : plural)}"
    end

    def create_nokogiri(path)
      content = if File.exist?(path) && !File.directory?(path)
                  File.open(path).read
                else
                  path
                end

      Nokogiri::HTML5(content)
    end

    def swap(href, replacement)
      replacement.each do |link, replace|
        href = href.gsub(link, replace)
      end
      href
    end
  end
end
