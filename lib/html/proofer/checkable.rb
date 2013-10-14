module HTML
  class Proofer
    class Checkable

      def initialize(obj, check)
        @src = obj['src']
        @href = obj['href']
        @alt = obj['alt']
        @name = obj['name']
        @id = obj['id']
        @check = check

        if @href && @check.options[:href_swap]
          @options[:href_swap].each do |link, replace|
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
        false
      end

      def ignore?
        uri = URI.parse url
        %w( mailto ).include?(uri.scheme) || @check.additional_href_ignores.include?(href)
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

        if path =~ /^\// #path relative to root
          base = @check.src
        elsif File.exist? File.expand_path path, @check.src #relative links, path is a file
          base = File.dirname @check.path
        else #relative link, path is a directory
          base = @check.path
        end

        file = File.join base, path

        # implicit /index.html support, with support for tailing slashes
        file = File.join path, "index.html" if File.directory? File.expand_path file, @check.src

        file
      end

      # checks if a file exists relative to the current pwd
      def exists?
        File.exist? absolute_path
      end

      def absolute_path
        path = file_path || @check.path
        File.expand_path path, Dir.pwd
      end

    end
  end
end
