#require './lib/html/proofer/checks'
require 'set'

module HTML
  class Proofer
    def initialize(src, opts = {:stopOnFail => false, :ext => ".html"})
      require './lib/html/proofer/checks'
      @srcDir = src
      @options = opts
    end

    def run
      success = true

      Find.find(@srcDir) do |path|
        if File.extname(path) == @options[:ext]
          html = Nokogiri::HTML(File.read(path))
          issues = run_checks(path, html)
          self.print_issues(issues)
        end
      end

      unless success
        raise "One (or more?) checks failed"
      end
    end

    def get_checks
      HTML::Proofer::Checks::Check.subclasses
    end

    def run_checks(path, html)
      issues = Set.new
      
      get_checks.each do |klass|
        puts "Running #{klass.name.split(/:/).pop()} check... "

        check = klass.new(path, html, @options)
        check.run

        issues.merge(check.issues)
      end
      issues
    end

    def external_href?(href)
      !!(href =~ %r{^(\/\/|[a-z\-]+:)})
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
