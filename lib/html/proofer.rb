require 'nokogiri'
require 'html/proofer/checks'

module HTML
  class Proofer
    def initialize(src, opts={})
      @srcDir = src
      @options = {:ext => ".html"}.merge(opts)
      @failedTests = []
    end

    def run
      get_checks.each do |klass|
        puts "Running #{klass.name.split(/:/).pop()} check... \n\n"

        Find.find(@srcDir) do |path|
          if File.extname(path) == @options[:ext]
            html = HTML::Proofer.create_nokogiri(path)
            check = klass.new(@srcDir, path, html, @options)
            check.run
            check.hydra.run
            self.print_issues(klass, check.issues)
          end
        end
      end

      if !@failedTests.empty?
        # make the hash default to 0 so that += will work correctly
        count = Hash.new(0)

        # iterate over the array, counting duplicate entries
        @failedTests.each do |v|
          count[v] += 1
        end

        count.each do |k, v|
          $stderr.puts "#{k} failed #{v} times"
        end
        raise "Tests ran, but found failures!"
      end
    end

    def self.create_nokogiri(path)
      path << "index.html" if File.directory? path #support for Jekyll-style links
      Nokogiri::HTML(File.read(path))
    end

    def get_checks
      HTML::Proofer::Checks::Check.subclasses
    end

    def print_issues(klass, issues)
      return if issues.empty?
      @failedTests.push klass
      issues.each do |issue|
        $stderr.puts issue + "\n\n"
      end
    end
  end
end
