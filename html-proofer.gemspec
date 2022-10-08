# frozen_string_literal: true

$LOAD_PATH.push(File.expand_path("lib", __dir__))
require "html_proofer/version"

Gem::Specification.new do |spec|
  spec.name          = "html-proofer"
  spec.version       = HTMLProofer::VERSION
  spec.authors       = ["Garen Torikian"]
  spec.email         = ["gjtorikian@gmail.com"]
  spec.description   = %(Test your rendered HTML files to make sure they're accurate.)
  spec.summary       = %(A set of tests to validate your HTML output. These tests check if your image references are legitimate, if they have alt tags, if your internal links are working, and so on. It's intended to be an all-in-one checker for your documentation output.)
  spec.homepage      = "https://github.com/gjtorikian/html-proofer"
  spec.license       = "MIT"
  all_files = %x(git ls-files -z).split("\x0")
  spec.files = all_files.grep(%r{^(lib)/})
  spec.bindir = "exe"
  spec.executables = ["htmlproofer"]
  spec.require_paths = ["lib"]
  spec.required_ruby_version = [">= 3.1", "< 4.0"]

  spec.metadata = {
    "funding_uri" => "https://github.com/sponsors/gjtorikian/",
    "rubygems_mfa_required" => "true",
  }

  spec.add_dependency("addressable",     "~> 2.3")
  spec.add_dependency("async",           "~> 2.1")
  spec.add_dependency("nokogiri",        "~> 1.13")
  spec.add_dependency("rainbow",         "~> 3.0")
  spec.add_dependency("typhoeus",        "~> 1.3")
  spec.add_dependency("yell",            "~> 2.0")
  spec.add_dependency("zeitwerk",        "~> 2.5")

  spec.add_development_dependency("awesome_print")
  spec.add_development_dependency("debug") if "#{RbConfig::CONFIG["MAJOR"]}.#{RbConfig::CONFIG["MINOR"]}".to_f >= 3.1
  spec.add_development_dependency("rake")
  spec.add_development_dependency("redcarpet")
  spec.add_development_dependency("rspec", "~> 3.1")
  spec.add_development_dependency("rubocop")
  spec.add_development_dependency("rubocop-rspec")
  spec.add_development_dependency("rubocop-standard")
  spec.add_development_dependency("timecop", "~> 0.8")
  spec.add_development_dependency("vcr", "~> 2.9")
end
