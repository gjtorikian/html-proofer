require 'nokogiri'
require File.dirname(__FILE__) + '/proofer/checkable'
require File.dirname(__FILE__) + '/proofer/checks'

module HTML
  class Proofer
    def initialize(src, opts={})
      @srcDir = src
      @options = {:ext => ".html"}.merge(opts)
    end

    def run
      total_files = 0
      failed_tests = []

      puts "Running #{get_checks} checks on #{@srcDir}... \n\n"

      Dir.glob("#{@srcDir}/**/*#{@options[:ext]}") do |path|
        total_files += 1
        html = HTML::Proofer.create_nokogiri(path)

        get_checks.each do |klass|
          check = klass.new(@srcDir, path, html, @options)
          check.run
          check.hydra.run
          failed_tests.concat(check.issues) if check.issues.length > 0
        end
      end

      puts "Ran on #{total_files} files!"

      if failed_tests.empty?
        puts "HTML-Proofer finished successfully.".green
        exit 0
      else
        failed_tests.each do |issue|
          $stderr.puts issue + "\n\n"
        end

        raise "HTML-Proofer found #{failed_tests.length} failures!"
      end
    end

    def self.create_nokogiri(path)
      path << "/index.html" if File.directory? path # support for Jekyll-style links
      content = File.open(path, "rb") {|f| f.read }
      Nokogiri::HTML(content)
    end

    def get_checks
      HTML::Proofer::Checks::Check.subclasses
    end
  end
end
