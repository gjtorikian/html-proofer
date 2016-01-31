# HTMLProofer

If you generate HTML files, _then this tool might be for you_.

`HTMLProofer` is a set of tests to validate your HTML output. These tests check if your image references are legitimate, if they have alt tags, if your internal links are working, and so on. It's intended to be an all-in-one checker for your output.

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

You can configure HTMLProofer to run on a file, an array of directories, or an array of links.

### Using in a script

1. Require the gem.
2. Generate some HTML.
3. Create a new instance of the `HTMLProofer` on your output folder.
4. `run` that instance.

Here's a simple example:

```ruby
require 'html-proofer'
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
HTMLProofer.check_directories(["./out"]).run
```

### Checking a single file

If you simply want to check a single file, use the `check_file` method:

``` ruby
HTMLProofer.check_file("/path/to/a/file.html").run
```

### Checking an array of links

With `check_links`, you can also pass in an array of links:

``` ruby
HTMLProofer.check_links(["http://github.com", "http://jekyllrb.com"])
```

This configures Proofer to just test those links to ensure they are valid. Note that for the command-line, you'll need to pass a special `--as-links` argument:

``` bash
htmlproofer www.google.com,www.github.com --as-links
```

### Using on the command-line

You'll get a new program called `htmlproofer` with this gem. Terrific!

Pass in options through the command-line, like this:

``` bash
htmlproofer ./out --url-swap wow:cow,mow:doh --ext .html.erb --url-ignore www.github.com
```

Note: since `url_swap` is a bit special, you'll pass in a pair of `RegEx:String` values.
`htmlproofer` will figure out what you mean.

### Using with Jekyll

Want to use HTML Proofer with your Jekyll site? Awesome. Simply add `gem 'html-proofer'`
to your `Gemfile` as described above, and add the following to your `Rakefile`,
using `rake test` to execute:

```ruby
require 'html-proofer'

task :test do
  sh "bundle exec jekyll build"
  HTMLProofer.check_directories(["./_site"]).run
end
```

Don't have or want a `Rakefile`? You can also do something like the following:

```bash
htmlproofer ./_site
```

## Ignoring content

Add the `data-proofer-ignore` attribute to any tag to ignore it from every check.

``` html
<a href="http://notareallink" data-proofer-ignore>Not checked.</a>
```

## Configuration

The `HTMLProofer` constructor takes an optional hash of additional options:

| Option | Description | Default |
| :----- | :---------- | :------ |
| `allow_hash_href` | If `true`, ignores the `href` `#`. | `false` |
| `alt_ignore` | An array of Strings or RegExps containing `img`s whose missing `alt` tags are safe to ignore. | `[]` |
| `check_external_hash` | Checks whether external hashes exist (even if the website exists). This slows the checker down. | `false` |
| `check_favicon` | Enables the favicon checker. | `false` |
| `check_html` | Enables HTML validation errors from Nokogiri | `false` |
|`checks_to_ignore`| An array of Strings indicating which checks you'd like to not perform. | `[]`
| `directory_index_file` | Sets the file to look for when a link refers to a directory. | `index.html` |
| `disable_external` | If `true`, does not run the external link checker, which can take a lot of time. | `false` |
| `empty_alt_ignore` | If `true`, ignores images with empty alt tags. | `false` |
| `enforce_https` | Fails a link if it's not marked as `https`. | `false` |
| `error_sort` | Defines the sort order for error output. Can be `:path`, `:desc`, or `:status`. | `:path`
| `ext` | The extension of your HTML files including the dot. | `.html`
| `external_only` | Only checks problems with external references. | `false`
| `file_ignore` | An array of Strings or RegExps containing file paths that are safe to ignore. | `[]` |
| `http_status_ignore` | An array of numbers representing status codes to ignore. | `[]`
| `log_level` | Sets the logging level, as determined by [Yell](https://github.com/rudionrails/yell). | `:info`
| `only_4xx` | Only reports errors for links that fall within the 4xx status code range. | `false` |
| `url_ignore` | An array of Strings or RegExps containing URLs that are safe to ignore. It affects all HTML attributes. Note that non-HTTP(S) URIs are always ignored. | `[]` |
| `url_swap` | A hash containing key-value pairs of `RegExp => String`. It transforms URLs that match `RegExp` into `String` via `gsub`. | `{}` |
| `verbose` | If `true`, outputs extra information as the checking happens. Useful for debugging. **Will be deprecated in a future release.**| `false` |

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
HTMLProofer.new("out/", {:ext => ".htm", :typhoeus => { :verbose => true, :ssl_verifyhost => 2 } })
```

This sets `HTMLProofer`'s extensions to use _.htm_, gives Typhoeus a configuration for it to be verbose, and use specific SSL settings. Check [the Typhoeus documentation](https://github.com/typhoeus/typhoeus#other-curl-options) for more information on what options it can receive.

You can similarly pass in a `:hydra` option with a hash configuration for Hydra.

The default value is `{ :typhoeus => { :followlocation => true }, :hydra => { :max_concurrency => 50 } }`.

### Configuring Parallel

[Parallel](https://github.com/grosser/parallel) can be used to speed internal file checks. You can pass in any of its options with the options namespace `:parallel`. For example:

``` ruby
HTMLProofer.check_directories(["out/"], {:ext => ".htm", :parallel => { :in_processes => 3} })
```

In this example, `:in_processes => 3` is passed into Parallel as a configuration option.

## Configuring caching

Checking external URLs can slow your tests down. If you'd like to speed that up, you can enable caching for your external links. Caching simply means to skip links that are valid for a certain period of time.

While running tests, HTMLProofer will always write to a log file within a directory called *tmp/.htmlproofer*. You should probably ignore this folder in your version control system. You can enable caching for this log file by passing in the option `:cache`, with a hash containing a single key, `:timeframe`. `:timeframe` defines the length of time the cache will be used before the link is checked again. The format of `:timeframe` is a number followed by a letter indicating the length of time. For example:

* `M` means months
* `w` means weeks
* `d` means days
* `h` means hours

For example, passing the following options means "recheck links older than thirty days":

``` ruby
{ :cache => { :timeframe => '30d' } }
```

And the following options means "recheck links older than two weeks":

``` ruby
{ :cache => { :timeframe => '2w' } }
```

Links that were failures are kept in the cache and *always* rechecked. If they pass, the cache is updated to note the new timestamp.

The cache operates on external links only.

## Logging

HTML-Proofer can be as noisy or as quiet as you'd like. If you set the `:log_level` option, you can better define the level of logging.

## Custom tests

Want to write your own test? Sure, that's possible!

Just create a classes that inherits from inherits from `HTMLProofer::Check`. This subclass must define one method called `run`. This is called on your content, and is responsible for performing the validation on whatever elements you like. When you catch a broken issue, call `add_issue(message, line_number: line)` to explain the error.

If you're working with the element's attributes (as most checks do), you'll also want to call `create_element(node)` as part of your suite. This contructs an object that contains all the attributes of the HTML element you're iterating on.

Here's an example custom test demonstrating these concepts. It reports `mailto` links that point to `octocat@github.com`:

``` ruby
class MailToOctocat < ::HTMLProofer::Check
  def mailto?
    return false if @link.data_ignore_proofer || blank?(@link.href)
    return @link.href.match /^mailto\:/
  end

  def octocat?
    return @link.href.match /\:octocat@github.com\Z/
  end

  def run
    @html.css('a').each do |node|
      @link = create_element(node)
      line = node.line

      if mailto? && octocat?
        return add_issue("Don't email the Octocat directly!", line_number: line)
      end
    end
  end
end
```

## Troubleshooting

### Certificates

To ignore certificates, turn off Typhoeus' SSL verification:

``` ruby
HTMLProofer.check_directories(["out/"], {
  :typhoeus => {
    :ssl_verifypeer => false,
    :ssl_verifyhost => 0}
}).run
```

### User-Agent

To change the User-Agent used by Typhoeus:

``` ruby
HTMLProofer.check_directories(["out/"], {
  :typhoeus => {
    :headers => { "User-Agent" => "Mozilla/5.0 (compatible; My New User-Agent)" }
}}).run
```

### Regular expressions

To exclude urls using regular expressions, include them between forward slashes and don't quote them:

``` ruby
HTMLProofer.check_directories(["out/"], {
  :url_ignore => [/example.com/],
}).run
```

## Real-life examples

Project | Repository
:--- | :---
[Raspberry Pi documentation](http://www.raspberrypi.org/documentation/) | [raspberrypi/documentation]( https://github.com/raspberrypi/documentation)
[Open Whisper Systems website](https://whispersystems.org/) | [WhisperSystems/whispersystems.org](https://github.com/WhisperSystems/whispersystems.org)
[Jekyll website](http://jekyllrb.com/) | [jekyll/jekyll](https://github.com/jekyll/jekyll)
