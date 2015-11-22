# HTML::Proofer

If you generate HTML files, _then this tool might be for you_.

`HTML::Proofer` is a set of tests to validate your HTML output. These tests check if your image references are legitimate, if they have alt tags, if your internal links are working, and so on. It's intended to be an all-in-one checker for your output.

[![Build Status](https://travis-ci.org/gjtorikian/html-proofer.svg?branch=master)](https://travis-ci.org/gjtorikian/html-proofer) [![Gem Version](https://badge.fury.io/rb/html-proofer.svg)](http://badge.fury.io/rb/html-proofer)

## Installation

Add this line to your application's Gemfile:

    gem 'html-proofer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install html-proofer

**NOTE:** When installation speed matters, set `NOKOGIRI_USE_SYSTEM_LIBRARIES` to `true` in your environment. This is useful for increasing the speed of your Continuous Integration builds.

## What's Tested?

You can enable or disable most of the following checks.

### Images

`img` elements:

* Whether all your images have alt tags
* Whether your internal image references are not broken
* Whether external images are showing

### Links

`a`, `link` elements:

* Whether your internal links are working
* Whether your internal hash references (`#linkToMe`) are working
* Whether external links are working
* Whether your links are not HTTPS

### Scripts

`script` elements:

* Whether your internal script references are working
* Whether external scripts are loading

### Favicon

* Whether your favicons are valid.

### HTML

* Whether your HTML markup is valid. This is done via [Nokogiri, to ensure well-formed markup](http://www.nokogiri.org/tutorials/ensuring_well_formed_markup.html).

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
htmlproof ./out --href-swap wow:cow,mow:doh --ext .html.erb --href-ignore www.github.com
```

Note: since `href_swap` is a bit special, you'll pass in a pair of `RegEx:String` values.
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

Don't have or want a `Rakefile`? You can also do something like the following:

```bash
htmlproof ./_site
```

### Array of links

Instead of a directory as the first argument, you can also pass in an array of links:

``` ruby
HTML::Proofer.new(["http://github.com", "http://jekyllrb.com"])
```

This configures Proofer to just test those links to ensure they are valid. Note that for the command-line, you'll need to pass a special `--as-links` argument:

``` bash
htmlproof www.google.com,www.github.com --as-links
```

## Ignoring content

Add the `data-proofer-ignore` attribute to any tag to ignore it from every check.

``` html
<a href="http://notareallink" data-proofer-ignore>Not checked.</a>
```

## Configuration

The `HTML::Proofer` constructor takes an optional hash of additional options:

| Option | Description | Default |
| :----- | :---------- | :------ |
| `allow_hash_href` | If `true`, ignores the `href` `#`. | `false` |
| `alt_ignore` | An array of Strings or RegExps containing `img`s whose missing `alt` tags are safe to ignore. | `[]` |
| `empty_alt_ignore` | If `true`, ignores images with empty alt tags. | `false` |
| `check_external_hash` | Checks whether external hashes exist (even if the website exists). This slows the checker down. | `false` |
| `check_favicon` | Enables the favicon checker. | `false` |
| `check_html` | Enables HTML validation errors from Nokogiri | `false` |
|`checks_to_ignore`| An array of Strings indicating which checks you'd like to not perform. | `[]`
| `directory_index_file` | Sets the file to look for when a link refers to a directory. | `index.html` |
| `disable_external` | If `true`, does not run the external link checker, which can take a lot of time. | `false` |
| `enforce_https` | Fails a link if it's not marked as `https`. | `false` |
| `error_sort` | Defines the sort order for error output. Can be `:path`, `:desc`, or `:status`. | `:path`
| `ext` | The extension of your HTML files including the dot. | `.html`
| `file_ignore` | An array of Strings or RegExps containing file paths that are safe to ignore. | `[]` |
| `href_ignore` | An array of Strings or RegExps containing `href`s that are safe to ignore. Note that non-HTTP(S) URIs are always ignored. **Will be renamed in a future release.** | `[]` |
| `href_swap` | A hash containing key-value pairs of `RegExp => String`. It transforms links that match `RegExp` into `String` via `gsub`. **Will be renamed in a future release.** | `{}` |
| `only_4xx` | Only reports errors for links that fall within the 4xx status code range. | `false` |
| `url_ignore` | An array of Strings or RegExps containing URLs that are safe to ignore. It affects all HTML attributes. Note that non-HTTP(S) URIs are always ignored. | `[]` |
| `verbose` | If `true`, outputs extra information as the checking happens. Useful for debugging. **Will be deprecated in a future release.**| `false` |
| `verbosity` | Sets the logging level, as determined by [Yell](https://github.com/rudionrails/yell). | `:info`

In addition, there are a few "namespaced" options. These are:

* `:validation`
* `:typhoeus`
* `:parallel`
* `:cache`

See below for more information.

### Configuring HTML validation rules

If `check_html` is `true`, Nokogiri performs additional validation on your HTML.

You can pass in additional options to configure this validation.

| Option | Description | Default |
| :----- | :---------- | :------ |
| `ignore_script_embeds` | When `check_html` is enabled, `script` tags containing markup [are reported as errors](http://git.io/vOovv). Enabling this option ignores those errors. | `false`

For example:

``` ruby
opts = { :check_html => true, :validation => { :ignore_script_embeds => true } }
```

### Configuring Typhoeus and Hydra

[Typhoeus](https://github.com/typhoeus/typhoeus) is used to make fast, parallel requests to external URLs. You can pass in any of Typhoeus' options for the external link checks with the options namespace of `:typhoeus`. For example:

``` ruby
HTML::Proofer.new("out/", {:ext => ".htm", :typhoeus => { :verbose => true, :ssl_verifyhost => 2 } })
```

This sets `HTML::Proofer`'s extensions to use _.htm_, gives Typhoeus a configuration for it to be verbose, and use specific SSL settings. Check [the Typhoeus documentation](https://github.com/typhoeus/typhoeus#other-curl-options) for more information on what options it can receive.

You can similarly pass in a `:hydra` option with a hash configuration for Hydra.

The default value is `{ :typhoeus => { :followlocation => true }, :hydra => { :max_concurrency => 50 } }`.

### Configuring Parallel

[Parallel](https://github.com/grosser/parallel) is used to speed internal file checks. You can pass in any of its options with the options namespace `:parallel`. For example:

``` ruby
HTML::Proofer.new("out/", {:ext => ".htm", :parallel => { :in_processes => 3} })
```

In this example, `:in_processes => 3` is passed into Parallel as a configuration option.

## Configuring caching

Checking external URLs can slow your tests down. If you'd like to speed that up, you can enable caching for your external links. Caching simply means to skip links that are valid.

While running tests, HTML::Proofer will always write to a log file within a directory called *tmp/.htmlproofer*. You should probably ignore this folder in your version control system. You can enable caching from this log file by passing in the option `:cache`, with a hash containing a single key, `:timeframe`. `:timeframe` defines the length of time the cache will be used before the link is checked again. The format of `:timeframe` is a number followed by a letter indicating the length of time. For example:

* `M` means months
* `w` means weeks
* `d` means days
* `h` means hours

So, passing the following options means "recheck links older than thirty days":

``` ruby
{ :cache => { :timeframe => '30d' } }
```

And the following options means "recheck links older than two weeks":

``` ruby
{ :cache => { :timeframe => '2w' } }
```

Links that were failures are kept in the cache and *always* rechecked. If they pass, the cache is updated to note the new timestamp.

The cache currently operates on external links only.

## Logging

HTML-Proofer can be as noisy or as quiet as you'd like. There are two ways to log information:

* If you set the `:verbose` option to `true`, HTML-Proofer will provide some debug information.
* If you set the `:verbosity` option, you can better define the level of logging. See the configuration table above for more information.

`:verbosity` is newer and offers better configuration. `:verbose` will be deprecated in a future 3.x.x release.

## Custom tests

Want to write your own test? Sure! Just create two classes--one that inherits from `HTML::Proofer::Checkable`, and another that inherits from `HTML::Proofer::CheckRunner`.

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
    @html.css('a').each do |node|
      link = OctocatLinkCheck.new(node, self)
      line = node.line

      if link.mailto? && link.octocat?
        return add_issue("Don't email the Octocat directly!", line)
      end
    end
  end
end
```

## Troubleshooting

### Certificates

To ignore certificates, turn off Typhoeus' SSL verification:

``` ruby
HTML::Proofer.new("out/", {
  :typhoeus => {
    :ssl_verifypeer => false,
    :ssl_verifyhost => 0}
}).run
```

### User-Agent

To change the User-Agent used by Typhoeus:

``` ruby
HTML::Proofer.new("out/", {
  :typhoeus => {
    :headers => { "User-Agent" => "Mozilla/5.0 (compatible; My New User-Agent)" }
}}).run
```

### Regular expressions

To exclude urls using regular expressions, include them between forward slashes and don't quote them:

``` ruby
HTML::Proofer.new("out/", {
  :url_ignore => [/example.com/],
}).run
```

## Real-life examples

Project | Repository
:--- | :---
[Raspberry Pi documentation](http://www.raspberrypi.org/documentation/) | [raspberrypi/documentation]( https://github.com/raspberrypi/documentation)
[Open Whisper Systems website](https://whispersystems.org/) | [WhisperSystems/whispersystems.org](https://github.com/WhisperSystems/whispersystems.org)
[Jekyll website](http://jekyllrb.com/) | [jekyll/jekyll](https://github.com/jekyll/jekyll)
