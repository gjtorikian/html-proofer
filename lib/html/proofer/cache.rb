module HTML
  class Proofer
    module Cache
      def create_nokogiri(path)
        if File.exist? path
          content = File.open(path).read
        else
          content = path
        end

        Nokogiri::HTML(content)
      end
      module_function :create_nokogiri
    end
  end
end
