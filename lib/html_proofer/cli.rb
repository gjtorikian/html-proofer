# frozen_string_literal: true

module HTMLProofer
  # The CLI is a class responsible of handling all the command line interface
  # logic.
  class CLI
    attr_reader :options

    def initialize
      @options = {}
    end

    def run(args = ARGV)
      @options, path = HTMLProofer::Configuration.new.parse_cli_options(args)

      paths = path.split(",")

      if @options[:as_links]
        links = path.split(",").map(&:strip)
        HTMLProofer.check_links(links, @options).run
      elsif File.directory?(paths.first)
        HTMLProofer.check_directories(paths, @options).run
      else
        HTMLProofer.check_file(path, @options).run
      end
    end
  end
end
