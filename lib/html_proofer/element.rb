# frozen_string_literal: true

require "addressable/uri"

module HTMLProofer
  # Represents the element currently being processed
  class Element
    include HTMLProofer::Utils

    attr_reader :node, :url, :base_url, :line, :content

    def initialize(runner, node, base_url: nil)
      @runner = runner
      @node = node

      swap_attributes!

      @base_url = base_url
      @url = Attribute::Url.new(runner, link_attribute, base_url: base_url, source: @runner.current_source, filename: @runner.current_filename)

      @line = node.line
      @content = node.content
    end

    def link_attribute
      meta_content || src || srcset || href
    end

    def meta_content
      return unless meta_tag?

      @node["content"]
    end

    def meta_tag?
      @node.name == "meta"
    end

    def src
      return if !img_tag? && !script_tag? && !source_tag?

      @node["src"]
    end

    def img_tag?
      @node.name == "img"
    end

    def script_tag?
      @node.name == "script"
    end

    def srcset
      return if !img_tag? && !source_tag?

      @node["srcset"]
    end

    def source_tag?
      @node.name == "source"
    end

    def href
      return if !a_tag? && !link_tag?

      @node["href"]
    end

    def a_tag?
      @node.name == "a"
    end

    def link_tag?
      @node.name == "link"
    end

    def aria_hidden?
      @node.attributes["aria-hidden"]&.value == "true"
    end

    def multiple_srcsets?
      !blank?(srcset) && srcset.split(",").size > 1
    end

    # From https://github.com/sindresorhus/srcset/blob/f7c48acd7facf18e94dec47e6b96e84e0f0e69dc/index.js#LL1-L16C71
    # This regex represents a loose rule of an “image candidate string”; see https://html.spec.whatwg.org/multipage/images.html#srcset-attribute
    # An “image candidate string” roughly consists of the following:
    # 1. Zero or more whitespace characters.
    # 2. A non-empty URL that does not start or end with `,`.
    # 3. Zero or more whitespace characters.
    # 4. An optional “descriptor” that starts with a whitespace character.
    # 5. Zero or more whitespace characters.
    # 6. Each image candidate string is separated by a `,`.
    # We intentionally implement a loose rule here so that we can perform more aggressive error handling and reporting in the below code.

    IMAGE_CANDIDATE_REGEX = /\s*([^,]\S*[^,](?:\s+[^,]+)?)\s*(?:,|$)/

    def srcsets
      return if blank?(srcset)

      srcset.split(IMAGE_CANDIDATE_REGEX).select.with_index do |_part, idx|
        idx.odd?
      end.map(&:strip)
    end

    def multiple_sizes?
      return false if blank?(srcsets)

      srcsets.any? do |srcset|
        !blank?(srcset) && srcset.split(" ").size > 1
      end
    end

    def srcsets_wo_sizes
      return if blank?(srcsets)

      srcsets.map do |srcset|
        srcset.split(" ").first
      end
    end

    def ignore?
      return true if @node.attributes["data-proofer-ignore"]
      return true if ancestors_ignorable?

      return true if url&.ignore?

      false
    end

    private def attribute_swapped?
      return false if blank?(@runner.options[:swap_attributes])

      attrs = @runner.options[:swap_attributes][@node.name]

      true unless blank?(attrs)
    end

    private def swap_attributes!
      return unless attribute_swapped?

      attr_swaps = @runner.options[:swap_attributes][@node.name]

      attr_swaps.flatten.each_slice(2) do |(old_attr, new_attr)|
        next if blank?(node[old_attr])

        node[new_attr] = node[old_attr]
        node.delete(old_attr)
      end
    end

    private def ancestors_ignorable?
      ancestors_attributes = @node.ancestors.map { |a| a.respond_to?(:attributes) && a.attributes }
      ancestors_attributes.pop # remove document at the end
      ancestors_attributes.any? { |a| !a["data-proofer-ignore"].nil? }
    end
  end
end
