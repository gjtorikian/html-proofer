# frozen_string_literal: true

module HTMLProofer
  class UrlValidator::Internal < UrlValidator
    attr_reader :internal_urls

    def initialize(runner, internal_urls)
      super(runner)

      @internal_urls = internal_urls
    end

    def validate
      if @cache.enabled?
        urls_to_check = @runner.load_internal_cache
        run_internal_link_checker(urls_to_check)
      else
        run_internal_link_checker(@internal_urls)
      end

      @failed_checks
    end

    def run_internal_link_checker(links)
      links.each_pair do |link, matched_files|
        matched_files.each do |metadata|
          url = HTMLProofer::Attribute::Url.new(@runner, link, base_url: metadata[:base_url])

          @runner.current_source = metadata[:source]
          @runner.current_path = metadata[:current_path]

          unless file_exists?(url)
            @failed_checks << Failure.new(@runner.current_path, 'Links > Internal', "internally linking to #{url}, which does not exist", line: metadata[:line], status: nil, content: nil)
            @cache.add_internal(url.to_s, metadata, false)
            next
          end

          unless hash_exists?(url)
            @failed_checks << Failure.new(@runner.current_path, 'Links > Internal', "internally linking to #{url}; the file exists, but the hash '#{url.hash}' does not", line: metadata[:line], status: nil, content: nil)
            @cache.add_internal(url.to_s, metadata, false)
            next
          end

          @cache.add_internal(url.to_s, metadata, true)
        end
      end

      @failed_checks
    end

    private def file_exists?(url)
      absolute_path = url.absolute_path
      return @runner.checked_paths[url.absolute_path] if @runner.checked_paths.key?(absolute_path)

      @runner.checked_paths[url.absolute_path] = File.exist?(absolute_path)
    end

    # verify the target hash
    private def hash_exists?(url)
      href_hash = url.hash
      return true if blank?(href_hash)

      # prevents searching files we didn't ask about
      return false unless url.known_extension?

      decoded_href_hash = Addressable::URI.unescape(href_hash)
      fragment_ids = [href_hash, decoded_href_hash]
      # https://www.w3.org/TR/html5/single-page.html#scroll-to-fragid
      fragment_ids.include?('top') || !find_fragments(fragment_ids, url).empty?
    end

    private def find_fragments(fragment_ids, url)
      xpaths = fragment_ids.uniq.flat_map do |frag_id|
        escaped_frag_id = "'#{frag_id.split("'").join("', \"'\", '")}', ''"
        [
          "//*[case_sensitive_equals(@id, concat(#{escaped_frag_id}))]",
          "//*[case_sensitive_equals(@name, concat(#{escaped_frag_id}))]"
        ]
      end
      xpaths << XpathFunctions.new

      html = create_nokogiri(url.absolute_path)
      html.xpath(*xpaths)
    end
  end
end
