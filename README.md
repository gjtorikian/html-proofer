# HTML::Proofer

If you generate HTML files, _then this tool might be for you_.

`HTML::Proofer` is a set of tests to validate your HTML output. These tests check if your image references are legitimate, if they have alt tags, if your internal links are working, and so on. It's intended to be an all-in-one checker for your output.

[![Build Status](https://travis-ci.org/gjtorikian/html-proofer.svg?branch=master)](https://travis-ci.org/gjtorikian/html-proofer)

## Installation

Add this line to your application's Gemfile:

    gem 'html-proofer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install html-proofer

**NOTE:** When installation speed matters, set `NOKOGIRI_USE_SYSTEM_LIBRARIES` to `true` in your environment. This is useful for increasing the speed of your Continuous Integration builds.

## Usage

### Using in a script

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

### Using on the command-line

You'll get a new program called `htmlproof` with this gem. Terrific!

Use it like you'd expect to:

``` bash
htmlproof run ./out --swap wow:cow,mow:doh --ext .html.erb --ignore www.github.com
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

## Configuration

The `HTML::Proofer` constructor takes an optional hash of additional options:

| Option | Description | Default |
| :----- | :---------- | :------ |
| `disable_external` | If `true`, does not run the external link checker, which can take a lot of time. | `false` |
| `ext` | The extension of your HTML files including the dot. | `.html`
| `favicon` | Enables the favicon checker. | `false` |
| `followlocation` | Follows external redirections. Amends missing trailing slashes to internal directories. | `true` |
| `directory_index_file` | Sets the file to look for when a link refers to a directory. | `index.html` |
| `href_ignore` | An array of Strings or RegExps containing `href`s that are safe to ignore. Certain URIs, like `mailto` and `tel`, are always ignored. | `[]` |
| `alt_ignore` | An array of Strings or RegExps containing `img`s whose missing `alt` tags are safe to ignore. | `[]` |
| `href_swap` | A hash containing key-value pairs of `RegExp => String`. It transforms links that match `RegExp` into `String` via `gsub`. | `{}` |
| `verbose` | If `true`, outputs extra information as the checking happens. Useful for debugging. | `false` |
| `only_4xx` | Only reports errors for links that fall within the 4xx status code range. | `false` |

You can also pass in any of Typhoeus' options for the external link check. For example:

``` ruby
HTML::Proofer.new("out/", {:ext => ".htm", :verbose => true, :ssl_verifyhost => 2 })
```

This sets `HTML::Proofer`'s extensions to use _.htm_, and gives Typhoeus a configuration for it to be verbose, and use specific SSL settings. Check [the Typhoeus documentation](https://github.com/typhoeus/typhoeus#other-curl-options) for more information on what options it can receive.

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

## Custom tests

Want to write your own test? Sure! Just create two classes--one that inherits from `HTML::Proofer::Checkable`, and another that inherits from `HTML::Proofer::Checks::Check`. `Checkable` defines various helper methods for your test, while `Checks::Check` actually runs across your content. `Checks::Check` should call `self.add_issue` on failures, to add them to the list.

Here's an example custom test that protects against `mailto` links:

``` ruby
class OctocatLink < ::HTML::Proofer::Checkable

  def mailto?
    return false if @data_ignore_proofer || @href.nil? || @href.empty?
    return @href.match /^mailto\:/
  end

  def octocat?
    return @href.match /\:octocat@github.com\Z/
  end

end

class MailToOctocat < ::HTML::Proofer::Checks::Check

  def run
    @html.css('a').each do |l|
      link = OctocatLink.new l, "octocat_link", self

      if link.mailto? && link.octocat?
        return self.add_issue("Don't email the Octocat directly!")
      end
    end
  end
end
```
