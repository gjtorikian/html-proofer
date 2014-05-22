# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "html-proofer"
  gem.version       = "0.6.8"
  gem.authors       = ["Garen Torikian"]
  gem.email         = ["gjtorikian@gmail.com"]
  gem.description   = %q{Test your rendered HTML files to make sure they're accurate.}
  gem.summary       = %q{A set of tests to validate your HTML output. These tests check if your image references are legitimate, if they have alt tags, if your internal links are working, and so on. It's intended to be an all-in-one checker for your documentation output.}
  gem.homepage      = "https://github.com/gjtorikian/html-proofer"
  gem.license       = "MIT"
  gem.executables   = ["htmlproof"]
  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "mercenary",       "~> 0.3.2"
  gem.add_dependency "nokogiri",        "~> 1.6.0"
  gem.add_dependency "colored",         "~> 1.2"
  gem.add_dependency "typhoeus",        "~> 0.6.7"
  gem.add_dependency "yell",            "~> 2.0"

  gem.add_development_dependency "html-pipeline", "~> 1.8"
  gem.add_development_dependency "escape_utils", "~> 1.0" # Ruby 2.1 fix
  gem.add_development_dependency "rspec", "~> 2.13.0"
  gem.add_development_dependency "rake"
end
