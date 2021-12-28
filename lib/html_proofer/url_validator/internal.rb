# frozen_string_literal: true

module HTMLProofer
  class UrlValidator::Internal < UrlValidator
    def initialize(runner, url)
      super(runner)
      @url = url
    end

    def unslashed_directory?
      @url.unslashed_directory?(@url.absolute_path)
    end

    def file_exists?
      return @runner.checked_paths[@url.absolute_path] if @runner.checked_paths.key?(@url.absolute_path)

      @runner.checked_paths[@url.absolute_path] = File.exist?(@url.absolute_path)
    end

    # verify the target hash
    def hash_exists?
      href_hash = @url.hash
      return true if blank?(href_hash)

      decoded_href_hash = Addressable::URI.unescape(href_hash)
      fragment_ids = [href_hash, decoded_href_hash]
      # https://www.w3.org/TR/html5/single-page.html#scroll-to-fragid
      fragment_ids.include?('top') || !find_fragments(fragment_ids).empty?
    end

    private def find_fragments(fragment_ids)
      xpaths = fragment_ids.uniq.flat_map do |frag_id|
        escaped_frag_id = "'#{frag_id.split("'").join("', \"'\", '")}', ''"
        [
          "//*[case_sensitive_equals(@id, concat(#{escaped_frag_id}))]",
          "//*[case_sensitive_equals(@name, concat(#{escaped_frag_id}))]"
        ]
      end
      xpaths << XpathFunctions.new

      html = create_nokogiri(@url.absolute_path)
      html.xpath(*xpaths)
    end
  end
end
