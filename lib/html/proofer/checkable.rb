require 'addressable/uri'
require_relative './utils'

module HTML
  class Proofer
    # Represents the superclass from which all checks derive.
    class Checkable
      include HTML::Proofer::Utils

      attr_reader :line

      def initialize(obj, check)
        obj.attributes.each_pair do |attribute, value|
          instance_variable_set("@#{attribute.tr('-:.', '_')}".to_sym, value.value)
        end

        @text = obj.content
        @check = check
        @checked_paths = {}
        @type = self.class.name
        @line = obj.line

        if @href && @check.options[:href_swap]
          @href = swap(@href, @check.options[:href_swap])
        end

        # fix up missing protocols
        @href.insert 0, 'http:' if @href =~ %r{^//}
        @src.insert 0, 'http:' if @src =~ %r{^//}
      end

      def url
        @src || @srcset || @href || ''
      end

      def valid?
        !parts.nil?
      end

      def parts
        @parts ||= Addressable::URI.parse url
      rescue URI::Error, Addressable::URI::InvalidURIError
        @parts = nil
      end

      def path
        Addressable::URI.unencode parts.path unless parts.nil?
      end

      def hash
        parts.fragment unless parts.nil?
      end

      def scheme
        parts.scheme unless parts.nil?
      end

      # path is to an external server
      def remote?
        %w( http https ).include? scheme
      end

      def non_http_remote?
        !scheme.nil? && !remote?
      end

      def ignore?
        return true if @data_proofer_ignore

        # ignore base64 encoded images
        if %w(ImageCheckable FaviconCheckable).include? @type
          return true if url.match(/^data:image/)
        end

        # ignore user defined URLs
        return true if ignores_pattern_check(@check.url_ignores)

        # ignore user defined hrefs
        if 'LinkCheckable' == @type
          return true if ignores_pattern_check(@check.href_ignores)
        end

        # ignore user defined alts
        if 'ImageCheckable' == @type
          return true if ignores_pattern_check(@check.alt_ignores)
        end
      end

      def ignore_empty_alt?
        @check.empty_alt_ignore
      end

      # path is external to the file
      def external?
        !internal?
      end

      # path is an anchor or a query
      def internal?
        url.start_with? '#', '?'
      end

      def file_path
        return if path.nil?

        if path =~ %r{^/} # path relative to root
          base = File.directory?(@check.src) ? @check.src : File.dirname(@check.src)
        elsif File.exist?(File.expand_path path, @check.src) # relative links, path is a file
          base = File.dirname @check.path
        elsif File.exist?(File.join(File.dirname(@check.path), path)) # relative links in nested dir, path is a file
          base = File.dirname @check.path
        else # relative link, path is a directory
          base = @check.path
        end

        file = File.join base, path

        # implicit index support
        if File.directory?(file) && !unslashed_directory?(file)
          file = File.join file, @check.options[:directory_index_file]
        end

        file
      end

      # checks if a file exists relative to the current pwd
      def exists?
        return @checked_paths[absolute_path] if @checked_paths.key? absolute_path
        @checked_paths[absolute_path] = File.exist? absolute_path
      end

      def absolute_path
        path = file_path || @check.path
        File.expand_path path, Dir.pwd
      end

      def ignores_pattern_check(links)
        links.each do |ignore|
          if ignore.is_a? String
            return true if ignore == url
          elsif ignore.is_a? Regexp
            return true if ignore =~ url
          end
        end

        false
      end

      def unslashed_directory?(file)
        File.directory?(file) && !file.end_with?(File::SEPARATOR) && !follow_location?
      end

      def follow_location?
        @check.typhoeus_opts && @check.typhoeus_opts[:followlocation]
      end

      private

      def real_attr(attr)
        attr.to_s unless attr.nil? || attr.empty?
      end
    end
  end
end
