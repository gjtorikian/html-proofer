require 'nokogiri'
require File.dirname(__FILE__) + '/proofer/checkable'
require File.dirname(__FILE__) + '/proofer/checks'

module HTML
  class Proofer
    def initialize(src, opts={})
      @srcDir = src
      @options = {:ext => ".html"}.merge(opts)
      @failedTests = []
    end

    def run
      total_files = 0

      puts "Running #{get_checks} checks... \n\n"

      glob_recursively("*#{@options[:ext]}") do |path|
        total_files += 1
        html = HTML::Proofer.create_nokogiri(path)

        get_checks.each do |klass|
          check = klass.new(@srcDir, path, html, @options)
          check.run
          check.hydra.run
          self.print_issues(klass, check.issues)
        end
      end

      puts "Ran on #{total_files} files!"

      if @failedTests.empty?
        puts "Tests executed successfully.".green
        exit 0
      else
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
      path << "/index.html" if File.directory? path # support for Jekyll-style links
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

    private 

    # from http://bit.ly/1iAxKzJ
    def glob_recursively( pattern, &block )
       begin
         Dir.glob(pattern, &block)
         dirs = Dir.glob(@srcDir).select { |f| File.directory? f }
         dirs.each do |dir|
           # Do not process symlink
           next if File.symlink? dir
           Dir.chdir dir
           glob_recursively(pattern, &block)
           Dir.chdir '..'
         end
       rescue SystemCallError => e
         # a safe no op
       end
     end
  end
end
