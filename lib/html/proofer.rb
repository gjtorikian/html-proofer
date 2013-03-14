require 'nokogiri'
require 'html/proofer/checks'

module HTML
  class Proofer
    def initialize(src, opts = {:ext => ".html"})
      @srcDir = src
      @options = opts
    end

    def run
      get_checks.each do |klass|
        issues = []
        puts "Running #{klass.name.split(/:/).pop()} check... \n\n"

        Find.find(@srcDir) do |path|
          if File.extname(path) == @options[:ext]
            html = HTML::Proofer.create_nokogiri(path)
            check = klass.new(path, html)
            check.run
            issues.concat(check.issues)
          end
        end

        self.print_issues(issues)
      end
    end

    def self.create_nokogiri(path)
      Nokogiri::HTML(File.read(path))
    end

    def get_checks
      HTML::Proofer::Checks::Check.subclasses
    end

    def print_issues(issues)
      return if issues.empty?
      issues.each do |issue|
        $stderr.puts issue + "\n\n"
      end
    end
  end
end
