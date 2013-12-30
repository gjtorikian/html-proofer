# HTML::Proofer

If you generate HTML files, _then this tool might be for you_.

`HTML::Proofer` is a set of tests to validate your HTML output. These tests check if your image references are legitimate, if they have alt tags, if your internal links are working, and so on. It's intended to be an all-in-one checker for your output.

[![Build Status](https://travis-ci.org/gjtorikian/html-proofer.png?branch=master)](https://travis-ci.org/gjtorikian/html-proofer) [![Gem Version](https://badge.fury.io/rb/html-proofer.png)](http://badge.fury.io/rb/html-proofer)

## Installation

Add this line to your application's Gemfile:

    gem 'html-proofer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install html-proofer

## Usage

### In a script

Require the gem; generate some HTML; create a new instance of the `HTML::Proofer` on
your output folder; then `run` it. Here's a simple example:

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
HTML::Proofer.new("./out").run
```

### Usage on the command-line

You'll get a new program called `htmlproof` with this gem. Jawesome!

Use it like you'd expect to:

``` bash
htmlproof run ./out --swap wow:cow,mow:doh --ext .html.erb --ignore www.github.com
```

Note: since `swap` is a bit special, you'll pass in a pair of `RegEx:String` values.
`htmlproof` will figure out what you mean.

## Usage with Jekyll

Want to use HTML Proofer with your Jekyll site? Awesome. Simply add `gem 'html-proofer'`
to your `Gemfile` as described above, and add the following to your `Rakefile`,
using `rake test` to execute:

```ruby
require 'html/proofer'

task :test do
  sh "bundle exec jekyll build"
  HTML::Proofer.new("./_site").run
end
```

Don't have or want a `Rakefile`? You _could_ also do something like the following:

```bash
htmlproof ./_site
```

## What's Tested?

* Whether all your images have alt tags
* Whether your internal image references are not broken
* Whether external images are showing
* Whether your internal links are not broken; this includes hash references (`#linkToMe`)
* Whether external links are working

## Configuration

The `HTML::Proofer` constructor takes an optional hash of additional options:

* `:ext`: the extension (including the `.`) of your HTML files (default: `.html`)
* `:href_swap`: a hash containing key-value pairs of `RegExp => String`. It transforms links that match `RegExp` into `String` via `gsub`.
* `:href_ignore`: an array of Strings containing `href`s that are safe to ignore (by default, `mailto` is always ignored)
* `:disable_external`: if `true`, does not run the external link checker, which can take a lot of time (default: `false`)

You can also pass in any of Typhoeus' options for the external link check. For example:

``` ruby
HTML::Proofer.new("out/", {:ext => ".htm", :verbose = > true, :ssl_verifyhost => 2 })
```

This sets `HTML::Proofer`'s' extensions to use _.htm_, and gives Typhoeus a configurtion for it to be verbose, and use specific SSL settings. Check the Typhoeus documentation for more information on what options it can receive.

## Ignoring links

To any `<a>` or `<img>` tag, you may add the `data-proofer-ignore` attribute to ignore the link.
