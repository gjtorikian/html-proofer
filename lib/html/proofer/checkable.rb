module HTML
  class Proofer
    class Checkable
      def initialize(obj, type, check)
        @src = obj['src']
        @href = obj['href']
        @alt = obj['alt']
        @name = obj['name']
        @id = obj['id']
        @data_ignore_proofer = obj['data-proofer-ignore']
        @check = check
        @checked_paths = {}
        @type = type

        if @href && @check.options[:href_swap]
          @check.options[:href_swap].each do |link, replace|
            @href = @href.gsub(link, replace)
          end
        end

      end

      def url
        @src || @href || ""
      end

      def valid?
        begin
          URI.parse url
        rescue
          false
        end
      end

      def parts
         URI.parse url
      end

      def path
        parts.path
      end

      def hash
        parts.fragment
      end

      # path is to an external server
      def remote?
        uri = URI.parse url
        %w( http https ).include?(uri.scheme)
      rescue URI::BadURIError
        false
      rescue URI::InvalidURIError
        if @type == "image"
          @ignored = true
          return true if url.match(/^data:image/)
        end

        false
      end

      def ignore?
        return true if @ignored || @data_ignore_proofer || @check.additional_href_ignores.include?(url)
        unless @check.additional_href_ignores.empty?
          @check.additional_href_ignores.each do |href_ignore|
            if href_ignore.is_a? String
              return true if href_ignore == url
            elsif href_ignore.is_a? Regexp
              return true if href_ignore =~ url
            end
          end
        end

        uri = URI.parse url
        %w( mailto ).include?(uri.scheme)
      rescue URI::BadURIError
        false
      rescue URI::InvalidURIError
        false
      end

      # path is external to the file
      def external?
        !internal?
      end

      # path is an anchor
      def internal?
        url[0] == "#"
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

        # implicit /index.html support, with support for tailing slashes
        file = File.join path, "index.html" if File.directory? File.expand_path file, @check.src

        file
      end

      # checks if a file exists relative to the current pwd
      def exists?
        return @checked_paths[absolute_path] if @checked_paths.has_key? absolute_path
        @checked_paths[absolute_path] = File.exist? absolute_path
      end

      def absolute_path
        path = file_path || @check.path
        File.expand_path path, Dir.pwd
      end
    end
  end
end
