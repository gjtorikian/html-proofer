# frozen_string_literal: true

require 'addressable/uri'

module HTMLProofer
  # Represents the element currently being processed
  class Element
    include HTMLProofer::Utils

    attr_reader :node, :url

    # attr_reader :id, :name, :alt, :href, :link, :src, :line, :data_proofer_ignore

    def initialize(runner, node, base_url:)
      @runner = runner
      @node = node

      @url = Attribute::Url.new(runner, link_attribute, base_url: base_url)

      # Construct readable ivars for every element
      # begin
      #   obj.attributes.each_pair do |attribute, value|
      #     name = attribute.tr('-:.;@', '_').to_s.to_sym
      #     (class << self; self; end).send(:attr_reader, name)
      #     instance_variable_set("@#{name}", value.value)
      #   end
      # rescue NameError => e
      #   @logger.log :error, "Attribute set `#{obj}` contains an error!"
      #   raise e
      # end

      # @aria_hidden = defined?(@aria_hidden) && @aria_hidden == 'true'

      # @data_proofer_ignore = defined?(@data_proofer_ignore)

      # @text = obj.content
      # @check = check
      # @type = check.class.name
      # @line = obj.line

      # @html = check.html

      # # fix up missing protocols
      # if defined?(@href)
      #   @href.insert(0, 'http:') if %r{^//}.match?(@href)
      # else
      #   @href = nil
      # end

      # if defined?(@src)
      #   @src.insert(0, 'http:') if %r{^//}.match?(@src)
      # else
      #   @src = nil
      # end

      # if defined?(@srcset)
      #   @srcset.insert(0, 'http:') if %r{^//}.match?(@srcset)
      # else
      #   @srcset = nil
      # end
    end

    def link_attribute
      src || srcset || href || ''
    end

    def src
      @node['src']
    end

    def srcset
      @node['srcset']
    end

    def href
      @node['href']
    end

    def aria_hidden?
      @node.attributes['aria-hidden']&.value == 'true'
    end

    def ignore?
      return true if @node.attributes['data-proofer-ignore']
      return true if ancestors_ignorable?

      return true if url.ignore?

      # ignore base64 encoded images
      return true if %w[HTMLProofer::Check::Images HTMLProofer::Check::Favicon].include?(@runner.current_check) && /^data:image/.match?(url.raw_attribute)

      # ignore user defined URLs
      return true if matches_ignore_pattern?(@runner.options[:url_ignore])
    end

    def matches_ignore_pattern?(links)
      return false unless links.is_a?(Array)

      links.each do |ignore|
        case ignore
        when String
          return true if ignore == url.raw_attribute
        when Regexp
          return true if ignore&.match?(url.raw_attribute)
        end
      end

      false
    end

    private def ancestors_ignorable?
      ancestors_attributes = @node.ancestors.map { |a| a.respond_to?(:attributes) && a.attributes }
      ancestors_attributes.pop # remove document at the end
      ancestors_attributes.any? { |a| !a['data-proofer-ignore'].nil? }
    end
  end
end
