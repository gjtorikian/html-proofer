# HTML::Proofer

If you generate HTML files, _then this tool might be for you_.

`HTML::Proofer` is a set of tests to validate your HTML output. These tests check if your image references are legitimate, if they have alt tags, if your internal links are working, and so on. It's intended to be an all-in-one checker for your output.

[![Build Status](https://travis-ci.org/gjtorikian/html-proofer.svg?branch=master)](https://travis-ci.org/gjtorikian/html-proofer) [![Gem Version](https://badge.fury.io/rb/html-proofer.svg)](http://badge.fury.io/rb/html-proofer) [![Test Coverage](https://codeclimate.com/github/gjtorikian/html-proofer/badges/coverage.svg)](https://codeclimate.com/github/gjtorikian/html-proofer)

## Installation

Add this line to your application's Gemfile:

    gem 'html-proofer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install html-proofer

**NOTE:** When installation speed matters, set `NOKOGIRI_USE_SYSTEM_LIBRARIES` to `true` in your environment. This is useful for increasing the speed of your Continuous Integration builds.

### Real-life examples

Project | Repository
:--- | :---
[Raspberry Pi documentation](http://www.raspberrypi.org/documentation/) | [raspberrypi/documentation]( https://github.com/raspberrypi/documentation)
[Open Whisper Systems website](https://whispersystems.org/) | [WhisperSystems/whispersystems.org](https://github.com/WhisperSystems/whispersystems.org)
[Jekyll website](http://jekyllrb.com/) | [jekyll/jekyll](https://github.com/jekyll/jekyll)

## What's Tested?

### Images

`img` elements:

* Whether all your images have alt tags
* Whether your internal image references are not broken
* Whether external images are showing

### Links

`a`, `link` elements:

* Whether your internal links are not broken; this includes hash references (`#linkToMe`)
* Whether external links are working

### Scripts

`script` elements:

* Whether your internal script references are not broken
* Whether external scripts are loading

### Favicon

Checks if your favicons are valid. This is an optional feature, set the `check_favicon` option to turn it on.

### HTML

Nokogiri looks at the markup and [provides errors](http://www.nokogiri.org/tutorials/ensuring_well_formed_markup.html) when parsing your document.
This is an optional feature, set the `check_html` option to enable validation errors from Nokogiri.

## Usage

### Using in a script

Require the gem; generate some HTML; create a new instance of the `HTML::Proofer` on
your output folder; then `run` it. Here's a simple example:

```ruby
require 'html/proofer'
require 'html/pipeline'
require 'find'

# make an out dir
Dir.mkdir("out") unless File.exist?("out")

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

### Using on the command-line

You'll get a new program called `htmlproof` with this gem. Terrific!

Use it like you'd expect to:

``` bash
htmlproof ./out --ext .html.erb --href-swap wow:cow,mow:doh --href-ignore www.github.com
```

Note: since `swap` is a bit special, you'll pass in a pair of `RegEx:String` values.
`htmlproof` will figure out what you mean.

### Using with Jekyll

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

## Configuration

The `HTML::Proofer` constructor takes an optional hash of additional options:

| Option | Description | Default |
| :----- | :---------- | :------ |
| `alt_ignore` | An array of Strings or RegExps containing `img`s whose missing `alt` tags are safe to ignore. | `[]` |
| `check_external_hash` | Checks whether external hashes exist (even if the website exists). This slows the checker down. | `false` |
|`checks_to_ignore`| An array of Strings indicating which checks you'd like to not perform. | `[]`
| `directory_index_file` | Sets the file to look for when a link refers to a directory. | `index.html` |
| `disable_external` | If `true`, does not run the external link checker, which can take a lot of time. | `false` |
| `error_sort` | Defines the sort order for error output. Can be `:path`, `:desc`, or `:status`. | `:path`
| `ext` | The extension of your HTML files including the dot. | `.html`
| `file_ignore` | An array of Strings or RegExps containing file paths that are safe to ignore. | `[]` |
| `href_ignore` | An array of Strings or RegExps containing `href`s that are safe to ignore. Note that non-HTTP(S) URIs are always ignored. | `[]` |
| `href_swap` | A hash containing key-value pairs of `RegExp => String`. It transforms links that match `RegExp` into `String` via `gsub`. | `{}` |
| `only_4xx` | Only reports errors for links that fall within the 4xx status code range. | `false` |
| `check_favicon` | Enables the favicon checker. | `false` |
| `check_html` | Enables HTML validation errors from Nokogiri | `false` |
| `verbose` | If `true`, outputs extra information as the checking happens. Useful for debugging. | `false` |

### Configuring Typhoeus and Hydra

[Typhoeus](https://github.com/typhoeus/typhoeus) is used to make fast, parallel requests to external URLs. You can pass in any of Typhoeus' options for the external link checks with the options namespace of `:typhoeus`. For example:

``` ruby
HTML::Proofer.new("out/", {:ext => ".htm", :typhoeus => { :verbose => true, :ssl_verifyhost => 2 } })
```

This sets `HTML::Proofer`'s extensions to use _.htm_, and gives Typhoeus a configuration for it to be verbose, and use specific SSL settings. Check [the Typhoeus documentation](https://github.com/typhoeus/typhoeus#other-curl-options) for more information on what options it can receive.

You can similarly pass in a `:hydra` option with a hash configuration for Hydra.

The default value is `typhoeus => { :followlocation => true }`.

### Configuring Parallel

[Parallel](https://github.com/grosser/parallel) is being used to speed internal file checks. You can pass in any of its options with the options "namespace" `:parallel`. For example:

``` ruby
HTML::Proofer.new("out/", {:ext => ".htm", :parallel => { :in_processes => 3} })
```

`:in_processes => 3` will be passed into Parallel as a configuration option.

### Array of links

Instead of a directory as the first argument, you can also pass in an array of links:

``` ruby
HTML::Proofer.new(["http://github.com", "http://jekyllrb.com"])
```

This configures Proofer to just test those links to ensure they are valid. Note that for the command-line, you'll need to pass a special `--as-links` argument:

``` bash
bin/htmlproof www.google.com,www.github.com --as-links
```

## Ignoring content

Add the `data-proofer-ignore` attribute to any tag to ignore it from the checks.


``` html
<a href="http://notareallink" data-proofer-ignore>Not checked.</a>
```

## Custom tests

Want to write your own test? Sure! Just create two classes--one that inherits from `HTML::Proofer::CheckRunner`, and another that inherits from `HTML::Proofer::Checkable`.

The `CheckRunner` subclass must define one method called `run`. This is called on your content, and is responsible for performing the validation on whatever elements you like. When you catch a broken issue, call `add_issue(message)` to explain the error.

The `Checkable` subclass defines various helper methods you can use as part of your test. Usually, you'll want to instantiate it within `run`. You have access to all of your element's attributes.

Here's an example custom test that protects against `mailto` links that point to `octocat@github.com`:

``` ruby
class OctocatLinkCheck < ::HTML::Proofer::Checkable

  def mailto?
    return false if @data_ignore_proofer || @href.nil? || @href.empty?
    return @href.match /^mailto\:/
  end

  def octocat?
    return @href.match /\:octocat@github.com\Z/
  end

end

class MailToOctocat < ::HTML::Proofer::CheckRunner

  def run
    @html.css('a').each do |l|
      link = OctocatLinkCheck.new l, self

      if link.mailto? && link.octocat?
        return add_issue("Don't email the Octocat directly!")
      end
    end
  end
end
```
