# frozen_string_literal: true

module HTMLProofer
  class Attribute
    class Url < HTMLProofer::Attribute
      attr_reader :url, :size, :source, :filename

      REMOTE_SCHEMES = ["http", "https"].freeze

      def initialize(runner, link_attribute, base_url: nil, source: nil, filename: nil, extract_size: false)
        super

        @source = source
        @filename = filename

        if @raw_attribute.nil?
          @url = nil
        else
          @url = @raw_attribute.delete("\u200b").strip
          @url, @size = @url.split(/\s+/) if extract_size
          @url = Addressable::URI.join(base_url, @url).to_s unless blank?(base_url)
          @url = "" if @url.nil?

          swap_urls!
          clean_url!
        end
      end

      def protocol_relative?
        url.start_with?("//")
      end

      def to_s
        @url
      end

      def known_extension?
        return true if hash_link?
        return true if path.end_with?("/")

        ext = File.extname(path)

        # no extension means we use the assumed one
        return @runner.options[:extensions].include?(@runner.options[:assume_extension]) if blank?(ext)

        @runner.options[:extensions].include?(ext)
      end

      def unknown_extension?
        !known_extension?
      end

      def ignore?
        return true if /^javascript:/.match?(@url)

        true if ignores_pattern?(@runner.options[:ignore_urls])
      end

      def valid?
        !parts.nil?
      end

      def path?
        !parts.host.nil? && !parts.path.nil?
      end

      def parts
        @parts ||= Addressable::URI.parse(@url)
      rescue URI::Error, Addressable::URI::InvalidURIError
        @parts = nil
      end

      def path
        Addressable::URI.unencode(parts.path) unless parts.nil?
      end

      def hash
        parts&.fragment
      end

      # Does the URL have a hash?
      def hash?
        !blank?(hash)
      end

      def scheme
        parts&.scheme
      end

      def remote?
        REMOTE_SCHEMES.include?(scheme)
      end

      def http?
        scheme == "http"
      end

      def https?
        scheme == "https"
      end

      def non_http_remote?
        !scheme.nil? && !remote?
      end

      def host
        parts&.host
      end

      def domain_path
        (host || "") + path
      end

      def query_values
        parts&.query_values
      end

      # checks if a file exists relative to the current pwd
      def exists?
        return true if base64?

        !resolved_path.nil?
      end

      def resolved_path
        path_to_resolve = absolute_path

        return @runner.resolved_paths[path_to_resolve] if @runner.resolved_paths.key?(path_to_resolve)

        # extensionless URLs
        path_with_extension = "#{path_to_resolve}#{@runner.options[:assume_extension]}"
        resolved = if @runner.options[:assume_extension] && File.file?(path_with_extension)
          path_with_extension # existence checked implicitly by File.file?
        # implicit index support
        elsif File.directory?(path_to_resolve) && !unslashed_directory?(path_to_resolve)
          path_with_index = File.join(path_to_resolve, @runner.options[:directory_index_file])
          path_with_index if File.file?(path_with_index)
        # explicit file or directory
        elsif File.exist?(path_to_resolve)
          path_to_resolve
        end
        @runner.resolved_paths[path_to_resolve] = resolved

        resolved
      end

      def base64?
        /^data:image/.match?(@raw_attribute)
      end

      def absolute_path
        path = full_path || @filename

        File.expand_path(path, Dir.pwd)
      end

      def full_path
        return if path.nil? || path.empty?

        base = if absolute_path?(path) # path relative to root
          # either overwrite with root_dir; or, if source is directory, use that; or, just get the source file's dirname
          @runner.options[:root_dir] || (File.directory?(@source) ? @source : File.dirname(@source))
        else
          # path relative to the file where the link is defined
          File.dirname(@filename)
        end

        File.join(base, path)
      end

      def unslashed_directory?(file)
        return false unless File.directory?(file)

        !file.end_with?(File::SEPARATOR) && !follow_location?
      end

      def follow_location?
        @runner.options[:typhoeus] && @runner.options[:typhoeus][:followlocation]
      end

      def absolute_path?(path)
        path.start_with?("/")
      end

      # path is external to the file
      def external?
        !internal?
      end

      def internal?
        relative_link? || internal_absolute_link? || hash_link?
      end

      def internal_absolute_link?
        url.start_with?("/")
      end

      def relative_link?
        return false if remote?

        hash_link? || param_link? || url.start_with?(".") || url =~ /^\S/
      end

      def link_points_to_same_page?
        hash_link || param_link
      end

      def hash_link?
        url.start_with?("#")
      end

      def has_hash?
        url.include?("#")
      end

      def param_link?
        url.start_with?("?")
      end

      def without_hash
        @url.to_s.sub(/##{hash}/, "")
      end

      # catch any obvious issues
      private def clean_url!
        parsed_url = Addressable::URI.parse(@url)
        url = if parsed_url.scheme.nil?
          parsed_url
        else
          parsed_url.normalize
        end.to_s

        # normalize strips this off, which causes issues with cache
        @url = if @url.end_with?("/") && !url.end_with?("/")
          "#{url}/"
        elsif !@url.end_with?("/") && url.end_with?("/")
          url.chop
        else
          url
        end
      rescue Addressable::URI::InvalidURIError # rubocop:disable Lint/SuppressedException; error will be reported at check time
      end

      private def swap_urls!
        return @url if blank?(replacements = @runner.options[:swap_urls])

        replacements.each do |link, replace|
          @url = @url.gsub(link, replace)
        end
      end

      private def ignores_pattern?(links_to_ignore)
        return false unless links_to_ignore.is_a?(Array)

        links_to_ignore.each do |link_to_ignore|
          case link_to_ignore
          when String
            return true if link_to_ignore == @raw_attribute
          when Regexp
            return true if link_to_ignore&.match?(@raw_attribute)
          end
        end

        false
      end
    end
  end
end
