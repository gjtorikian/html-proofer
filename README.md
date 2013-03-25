# HTML::Proofer

Generate HTML files? Use them for documentation? Great, then this tool might be for you.

Here are a set of tests to validate your HTML output. These tests check if your image references are legitimate, if they have alt tags, if your internal links are working, and so on. It's intended to be an all-in-one checker for your documentation output.

## Installation

Add this line to your application's Gemfile:

    gem 'html-proofer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install html-proofer

## Usage

Require the gem; generate some HTML; create a new instance of the `HTML::Proofer` on 
your out folder; then `run` it:

```ruby
require 'html/proofer'
require 'html/pipeline'
require 'find'

# make an out dir
Dir.mkdir("out") unless File.exists?("out")

pipeline = HTML::Pipeline.new [
  HTML::Pipeline::MarkdownFilter,
  HTML::Pipeline::TableOfContentsFilter
], :gfm => true

# iterate over files, and generate HTML from Markdown
Find.find("./docs") do |path|
  if File.extname(path) == ".md"
    contents = File.read(path)
    result = pipeline.call(contents)

    File.open("out/#{path.split("/").pop.sub('.md', '.html')}", 'w') { |file| file.write(result[:output].to_s) }
  end
end

# test your out dir!
tester = HTML::Proofer.new("./out")
tester.run
```

The `HTML::Proofer` constructor takes an optional hash of additional options:

* `:ext`: the extension (including the `.`) of your HTML files (default: `.html`)
* `:href_swap`: a hash containing key-value pairs of `RegExp => String`. It transforms links that match `RegExp` into `String` via `gsub`.
* `:href_ignore`: an array of Strings containing `href`s that are safe to ignore

## What's Tested?

* Whether all your images have alt tags
* Whether your internal image references are not broken
* Whether external images are showing
* Whether your internal links are not broken; this includes hash references (`#linkToMe`)
* Whether external links are working