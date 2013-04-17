require 'nokogiri'
require 'html/proofer/checks'

module HTML
  class Proofer
    def initialize(src, opts={})
      @srcDir = src
      @options = {:ext => ".html"}.merge(opts)
    end

    def run
      get_checks.each do |klass|
        issues = []
        puts "Running #{klass.name.split(/:/).pop()} check... \n\n"

        Find.find(@srcDir) do |path|
          if File.extname(path) == @options[:ext]
            html = HTML::Proofer.create_nokogiri(path)
            check = klass.new(path, html, @options)
            check.run
            self.print_issues(klass, check.issues)
          end
        end
      end
    end

    def self.create_nokogiri(path)
      Nokogiri::HTML(File.read(path))
    end

    def get_checks
      HTML::Proofer::Checks::Check.subclasses
    end

    def print_issues(klass, issues)
      return if issues.empty?
      raise "#{klass} has failing tests"
      issues.each do |issue|
        $stderr.puts issue + "\n\n"
      end
    end
  end
end
