require 'addressable/uri'

module HTML
  class Proofer
    # Represents the superclass from which all checks derive.
    class Checkable
      def initialize(obj, check)
        obj.attributes.each_pair do |attribute, value|
          next if value.value.empty?
          self.instance_variable_set("@#{attribute}".to_sym, value.value)
        end

        @data_ignore_proofer = obj['data-proofer-ignore']
        @content = obj.content
        @check = check
        @checked_paths = {}
        @type = self.class.name

        if @href && @check.options[:href_swap]
          @check.options[:href_swap].each do |link, replace|
            @href = @href.gsub(link, replace)
          end
        end

        # fix up missing protocols
        @href.insert 0, 'http:' if @href =~ %r{^//}
        @src.insert 0, 'http:' if @src =~ %r{^//}
      end

      def url
        @src || @href || ''
      end

      def valid?
        !parts.nil?
      end

      def parts
        @parts ||= Addressable::URI.parse url
      rescue URI::Error
        @parts = nil
      end

      def path
        parts.path unless parts.nil?
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
        return true if @data_ignore_proofer

        case @type
        when 'Favicon'
          return true if url.match(/^data:image/)
        when 'Link'
          return true if ignores_pattern_check(@check.href_ignores)
        when 'Image'
          return true if url.match(/^data:image/)
          return true if ignores_pattern_check(@check.alt_ignores)
        end
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

        if path =~ /^\// # path relative to root
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
        File.directory?(file) && !file.end_with?(File::SEPARATOR) && !@check.options[:followlocation]
      end

      private

      def real_attr(attr)
        attr.to_s unless attr.nil? || attr.empty?
      end

    end
  end
end
