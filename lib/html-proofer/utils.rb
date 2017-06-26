require 'nokogiri'
require 'stat'

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


    def init_stat
      process = StatModule::Process.new('HTMLProofer')
      process.version = "#{HTMLProofer::VERSION}"
      process.description = 'If you generate HTML files, then this tool might be for you.'
      process.maintainer = 'Garen Torikian'
      process.email = 'gjtorikian@gmail.com'
      process.website = 'https://github.com/gjtorikian/html-proofer'
      StatModule::Stat.new(process)
    end
    module_function :init_stat
  end
end
