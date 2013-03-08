#!/usr/bin/env rake
require "bundler/gem_tasks"
 
require 'rake/testtask'
 
Rake::TestTask.new do |t|
  t.libs << 'lib/doc-tester'
  t.test_files = FileList['test/doc-tester/*_test.rb']
  t.verbose = true
end
 
task :default => :test