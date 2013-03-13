# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "html/proofer/version"

Gem::Specification.new do |gem|
  gem.name          = "html-proofer"
  gem.version       = HTML::Proofer::VERSION
  gem.authors       = ["Garen Torikian"]
  gem.email         = ["gjtorikian@gmail.com"]
  gem.description   = %q{Tests your rendered Markdown to make sure it's accurate.}
  gem.summary       = %q{A set of tests to validate your HTML output. These tests check if your image references are legitimate, if they have alt tags, if your internal links are working, and so on. It's intended to be an all-in-one checker for your documentation output.}
  gem.homepage      = "https://github.com/gjtorikian/html-proofer"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "nokogiri",        "~> 1.5.6"

  gem.add_development_dependency "html-pipeline", "~> 0.0.8"
end
