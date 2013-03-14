#require './lib/html/proofer/checks'
require 'nokogiri'

module HTML
  class Proofer
    def initialize(src, opts = {:ext => ".html"})
      require './lib/html/proofer/checks'
      @srcDir = src
      @options = opts
    end

    def run
      Find.find(@srcDir) do |path|
        if File.extname(path) == @options[:ext]
          html = create_nokogiri
          issues = run_checks(path, html)
          self.print_issues(issues)
        end
      end
    end

    def self.create_nokogiri(path)
      Nokogiri::HTML(File.read(path))
    end

    def get_checks
      HTML::Proofer::Checks::Check.subclasses
    end

    def run_checks(path, html)
      issues = []

      get_checks.each do |klass|
        puts "Running #{klass.name.split(/:/).pop()} check... "

        check = klass.new(path, html, @options)
        check.run

        issues.merge(check.issues)
      end
      issues
    end

    def print_issues(issues)
      return if issues.empty?
      puts "Issues found!"
      issues.each do |issue|
        $stderr.puts issue
      end
    end
  end
end
