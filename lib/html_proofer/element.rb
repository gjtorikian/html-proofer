# frozen_string_literal: true

require 'addressable/uri'

module HTMLProofer
  # Represents the element currently being processed
  class Element
    include HTMLProofer::Utils

    attr_reader :node, :url, :base_url, :line, :content

    def initialize(runner, node, base_url: nil)
      @runner = runner
      @node = node

      @base_url = base_url
      @url = Attribute::Url.new(runner, link_attribute, base_url: base_url)

      @line = node.line
      @content = node.content
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
      @node['src'] if img_tag? || script_tag? || source_tag?
    end

    def img_tag?
      @node.name == 'img'
    end

    def script_tag?
      @node.name == 'script'
    end

    def srcset
      @node['srcset'] if img_tag? || source_tag?
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
