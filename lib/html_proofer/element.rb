# frozen_string_literal: true

require 'addressable/uri'

module HTMLProofer
  # Represents the element currently being processed
  class Element
    include HTMLProofer::Utils

    attr_reader :node, :url, :line, :content

    def initialize(runner, node, base_url: nil)
      @runner = runner
      @node = node

      @url = Attribute::Url.new(runner, link_attribute, base_url: base_url)

      @line = node.line
      @content = node.content

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
      meta_content || src || srcset || href
    end

    def meta_content
      @node['content'] if meta_tag?
    end

    def meta_tag?
      @node.name == 'meta'
    end

    def src
      @node['src'] if img_tag? || script_tag?
    end

    def img_tag?
      @node.name == 'img'
    end

    def script_tag?
      @node.name == 'script'
    end

    def srcset
      @node['srcset'] if source_tag?
    end

    def source_tag?
      @node.name == 'source'
    end

    def href
      @node['href'] if a_tag? || link_tag?
    end

    def a_tag?
      @node.name == 'a'
    end

    def link_tag?
      @node.name == 'link'
    end

    def aria_hidden?
      @node.attributes['aria-hidden']&.value == 'true'
    end

    def ignore?
      return true if @node.attributes['data-proofer-ignore']
      return true if ancestors_ignorable?

      return true if url&.ignore?

      false
    end

    private def ancestors_ignorable?
      ancestors_attributes = @node.ancestors.map { |a| a.respond_to?(:attributes) && a.attributes }
      ancestors_attributes.pop # remove document at the end
      ancestors_attributes.any? { |a| !a['data-proofer-ignore'].nil? }
    end
  end
end
