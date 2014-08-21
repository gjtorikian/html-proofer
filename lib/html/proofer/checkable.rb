module HTML
  class Proofer
    class Checkable
      def initialize(obj, type, check)
        @src = obj['src']
        @href = obj['href']
        @alt = obj['alt']
        @name = obj['name']
        @id = obj['id']
        @rel = obj['rel']

        @data_ignore_proofer = obj['data-proofer-ignore']
        @content = obj.content
        @check = check
        @checked_paths = {}
        @type = type

        if @href && @check.options[:href_swap]
          @check.options[:href_swap].each do |link, replace|
            @href = @href.gsub(link, replace)
          end
        end

        # fix up missing protocols
        @href.insert 0, "http:" if @href =~ /^\/\//
        @src.insert 0, "http:" if @src =~ /^\/\//

      end

      def url
        @src || @href || ""
      end

      def valid?
        !parts.nil?
      end

      def parts
        URI::Parser.new(:ESCAPED => '\%|\|').parse url
      rescue URI::Error
        nil
      end

      def path
        parts.path if !parts.nil?
      end

      def hash
        parts.fragment if !parts.nil?
      end

      def scheme
        parts.scheme if !parts.nil?
      end

      # path is to an external server
      def remote?
        %w( http https ).include? scheme
      end

      def ignore?
        return true if @data_ignore_proofer

        case @type
        when "favicon"
          return true if url.match(/^data:image/)
        when "link"
          return true if ignores_pattern_check(@check.additional_href_ignores)
        when "image"
          return true if url.match(/^data:image/)
          return true if ignores_pattern_check(@check.additional_alt_ignores)
        end

        %w( mailto tel ).include? scheme
      end

      # path is external to the file
      def external?
        !internal?
      end

      # path is an anchor or a query
      def internal?
        url.start_with? "#", "?"
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

        # implicit index support, with support for trailing slashes
        if File.directory? file and slashed? file
          File.join file, @check.options[:directory_index]
        elsif File.directory? file and @check.options[:followlocation]
          File.join file, @check.options[:directory_index]
        else
          file
        end
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

      def slashed?(path)
        path.end_with? File::SEPARATOR
      end
    end
  end
end
