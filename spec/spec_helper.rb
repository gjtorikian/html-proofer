require 'bundler/setup'
require_relative "../lib/html-proofer"

require File.expand_path('../../lib/html/proofer/version.rb', __FILE__)

FIXTURES_DIR = "spec/html/proofer/fixtures"

RSpec.configure do |config|
  # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate
end