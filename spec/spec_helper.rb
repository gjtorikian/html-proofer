require 'bundler/setup'
require_relative "../lib/html/proofer.rb"
require_relative "../lib/html/proofer/checks.rb"

require File.expand_path('../../lib/html/proofer/version.rb', __FILE__)

FIXTURES_DIR = "spec/html/proofer/fixtures"