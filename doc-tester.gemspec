# -*- encoding: utf-8 -*-
require File.expand_path("../lib/doc-tester/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "doc-tester"
  gem.version       = Doc::Tester::VERSION
  gem.authors       = ["Garen Torikian"]
  gem.email         = ["gjtorikian@gmail.com"]
  gem.description   = %q{Tests your rendered Markdown to make sure it's accurate.}
  gem.summary       = %q{A set of tests to validate your HTML output. These tests check if your image references are legitimate, if they have alt tags, if your internal links are working, and so on. It's intended to be an all-in-one checker for your documentation output.}
  gem.homepage      = "https://github.com/gjtorikian/doc-tester"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
