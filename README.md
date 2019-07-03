# HTMLProofer

If you generate HTML files, _then this tool might be for you_.

[![Build Status](https://travis-ci.org/gjtorikian/html-proofer.svg?branch=master)](https://travis-ci.org/gjtorikian/html-proofer) [![Gem Version](https://badge.fury.io/rb/html-proofer.svg)](http://badge.fury.io/rb/html-proofer) [![codecov](https://codecov.io/gh/gjtorikian/html-proofer/branch/master/graph/badge.svg)](https://codecov.io/gh/gjtorikian/html-proofer)


## Project scope

HTMLProofer is a set of tests to validate your HTML output. These tests check if your image references are legitimate, if they have alt tags, if your internal links are working, and so on. It's intended to be an all-in-one checker for your output.

In scope for this project is any well-known and widely-used test for HTML document quality. A major use for this project is continuous integration -- so we must have reliable results. We usually balance correctness over performance. And, if necessary, we should be able to trace this program's detection of HTML errors back to documented best practices or standards, such as W3 specifications.

**Third-party modules.** We want this product to be useful for continuous integration so we prefer to avoid subjective tests which are prone to false positive results, such as spell checkers, indentation checkers, etc. If you want to work on these items, please see [the section on custom tests](#custom-tests) and consider adding an implementation as a third-party module.

**Advanced configuration.** Most front-end developers can test their HTML using [our command line program](#using-on-the-command-line). Advanced configuration will [require using Ruby](https://github.com/gjtorikian/html-proofer/wiki/Using-HTMLProofer-From-Ruby-and-Travis).

## Installation

Add this line to your application's Gemfile:

    gem 'html-proofer'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install html-proofer

**NOTE:** When installation speed matters, set `NOKOGIRI_USE_SYSTEM_LIBRARIES` to `true` in your environment. This is useful for increasing the speed of your Continuous Integration builds.

## What's tested?

Below is mostly comprehensive list of checks that HTMLProofer can perform.

### Images

`img` elements:

* Whether all your images have alt tags
* Whether your internal image references are not broken
* Whether external images are showing
* Whether your images are HTTP

### Links

`a`, `link` elements:

* Whether your internal links are working
* Whether your internal hash references (`#linkToMe`) are working
* Whether external links are working
* Whether your links are HTTPS
* Whether CORS/SRI is enabled

### Scripts

`script` elements:

* Whether your internal script references are working
* Whether external scripts are loading
* Whether CORS/SRI is enabled

### Favicon

* Whether your favicons are valid.

### OpenGraph

* Whether the images and URLs in the OpenGraph metadata are valid.

### HTML

* Whether your HTML markup is valid. This is done via [Nokogiri](http://www.nokogiri.org/tutorials/ensuring_well_formed_markup.html) to ensure well-formed markup.

## Usage

You can configure HTMLProofer to run on:

* a file
* a directory
* an array of directories
* an array of links

It can also run through the command-line, Docker, or as Rack middleware.

### Using in a script

1. Require the gem.
2. Generate some HTML.
3. Create a new instance of the `HTMLProofer` on your output folder.
4. `run` that instance.

Here's an example:

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
HTMLProofer.check_directory("./out").run
```

### Checking a single file

If you simply want to check a single file, use the `check_file` method:

``` ruby
HTMLProofer.check_file('/path/to/a/file.html').run
```

### Checking directories

If you want to check a directory, use `check_directory`:

``` ruby
HTMLProofer.check_directory('./out').run
```

If you want to check multiple directories, use `check_directories`:

``` ruby
HTMLProofer.check_directories(['./one', './two']).run
```

### Checking an array of links

With `check_links`, you can also pass in an array of links:

``` ruby
HTMLProofer.check_links(['http://github.com', 'http://jekyllrb.com']).run
```

This configures Proofer to just test those links to ensure they are valid. Note that for the command-line, you'll need to pass a special `--as-links` argument:

**Note:** flags are different from the default ones provided above. The underscores are replaced with dashes.

`allow_hash_href` will be `--allow-hash-href`


``` bash
htmlproofer www.google.com,www.github.com --as-links
```

### Using on the command-line

You'll also get a new program called `htmlproofer` with this gem. Terrific!

Pass in options through the command-line as flags, like this:

``` bash
htmlproofer --extension .html.erb ./out
```

Use `htmlproofer --help` to see all command line options, or [take a peek here](https://github.com/gjtorikian/html-proofer/blob/master/bin/htmlproofer).

#### Special cases for the command-line

For options which require an array of input, surrounded the value with quotes, and don't use
any spaces. For example, to exclude an array of HTTP status code, you might do:

``` bash
htmlproofer --http-status-ignore "999,401,404" ./out
```

For something like `url-ignore`, and other options that require an array of regular expressions,
you can pass in a syntax like this:

``` bash
htmlproofer --url-ignore "/www.github.com/,/foo.com/" ./out
```

Since `url_swap` is a bit special, you'll pass in a pair of `RegEx:String`
values. The escape sequences `\:` should be used to produce literal
`:`s `htmlproofer` will figure out what you mean.

``` bash
htmlproofer --url-swap "wow:cow,mow:doh" --extension .html.erb --url-ignore www.github.com ./out
```

### Using with Jekyll

Want to use HTML Proofer with your Jekyll site? Awesome. Simply add `gem 'html-proofer'`
to your `Gemfile` as described above, and add the following to your `Rakefile`,
using `rake test` to execute:

```ruby
require 'html-proofer'

task :test do
  sh "bundle exec jekyll build"
  options = { :assume_extension => true }
  HTMLProofer.check_directory("./_site", options).run
end
```

Don't have or want a `Rakefile`? You can also do something like the following:

```bash
htmlproofer --assume-extension ./_site
```

### Using through Docker

If you have trouble with (or don't want to) install Ruby/Nokogiri, the command-line tool can be run through Docker. See [html-proofer-docker](https://github.com/18F/html-proofer-docker) for more information.

### Using as Rack middleware

You can run html-proofer as part of your Rack middleware to validate your HTML at runtime. For example, in Rails, add these lines to `config/application.rb`:

```ruby
  config.middleware.use HTMLProofer::Middleware if Rails.env.test?
  config.middleware.use HTMLProofer::Middleware if Rails.env.development?
```

This will raise an error at runtime if your HTML is invalid. You can choose to skip validation of a page by adding `?proofer-ignore` to the URL.

This is particularly helpful for projects which have extensive CI, since any invalid HTML will fail your build.

## Ignoring content

Add the `data-proofer-ignore` attribute to any tag to ignore it from every check.

``` html
<a href="http://notareallink" data-proofer-ignore>Not checked.</a>
```

This can also apply to parent elements, all the way up to the `<html>` tag:

``` html
<div data-proofer-ignore>
  <a href="http://notareallink">Not checked because of parent.</a>
</div>
```

## Ignoring new files

Say you've got some new files in a pull request, and your tests are failing because links to those files are not live yet. One thing you can do is run a diff against your base branch and explicitly ignore the new files, like this:

```ruby
  directories = %w(content)
  merge_base = `git merge-base origin/production HEAD`.chomp
  diffable_files = `git diff -z --name-only --diff-filter=AC #{merge_base}`.split("\0")
  diffable_files = diffable_files.select do |filename|
    next true if directories.include?(File.dirname(filename))
    filename.end_with?('.md')
  end.map { |f| Regexp.new(File.basename(f, File.extname(f))) }

  HTMLProofer.check_directory('./output', { url_ignore: diffable_files }).run
```

## Configuration

The `HTMLProofer` constructor takes an optional hash of additional options:

| Option | Description | Default |
| :----- | :---------- | :------ |
| `allow_missing_href` | If `true`, does not flag `a` tags missing `href` (this is the default for HTML5). | `false` |
| `allow_hash_href` | If `true`, ignores the `href="#"`. | `false` |
| `alt_ignore` | An array of Strings or RegExps containing `img`s whose missing `alt` tags are safe to ignore. | `[]` |
| `assume_extension` | Automatically add extension (e.g. `.html`) to file paths, to allow extensionless URLs (as supported by Jekyll 3 and GitHub Pages) | `false` |
| `check_external_hash` | Checks whether external hashes exist (even if the webpage exists). This slows the checker down. | `false` |
| `check_favicon` | Enables the favicon checker. | `false` |
| `check_opengraph` | Enables the Open Graph checker. | `false` |
| `check_html` | Enables HTML validation errors from Nokogiri | `false` |
| `check_img_http` | Fails an image if it's marked as `http` | `false` |
|`checks_to_ignore`| An array of Strings indicating which checks you'd like to not perform. | `[]`
| `directory_index_file` | Sets the file to look for when a link refers to a directory. | `index.html` |
| `disable_external` | If `true`, does not run the external link checker, which can take a lot of time. | `false` |
| `empty_alt_ignore` | If `true`, ignores images with empty alt tags. | `false` |
| `enforce_https` | Fails a link if it's not marked as `https`. | `false` |
| `error_sort` | Defines the sort order for error output. Can be `:path`, `:desc`, or `:status`. | `:path`
| `extension` | The extension of your HTML files including the dot. | `.html`
| `external_only` | Only checks problems with external references. | `false`
| `file_ignore` | An array of Strings or RegExps containing file paths that are safe to ignore. | `[]` |
| `http_status_ignore` | An array of numbers representing status codes to ignore. | `[]`
| `internal_domains`| An array of Strings containing domains that will be treated as internal urls. | `[]` |
| `log_level` | Sets the logging level, as determined by [Yell](https://github.com/rudionrails/yell). One of `:debug`, `:info`, `:warn`, `:error`, or `:fatal`. | `:info`
| `only_4xx` | Only reports errors for links that fall within the 4xx status code range. | `false` |
| `typhoeus_config` | A JSON-formatted string. Parsed using `JSON.parse` and mapped on top of the default configuration values so that they can be overridden. | `{}` |
| `url_ignore` | An array of Strings or RegExps containing URLs that are safe to ignore. It affects all HTML attributes. Note that non-HTTP(S) URIs are always ignored. | `[]` |
| `url_swap` | A hash containing key-value pairs of `RegExp => String`. It transforms URLs that match `RegExp` into `String` via `gsub`. | `{}` |
| `verbose` | If `true`, outputs extra information as the checking happens. Useful for debugging. **Will be deprecated in a future release.**| `false` |

In addition, there are a few "namespaced" options. These are:

* `:validation`
* `:typhoeus` / `:hydra`
* `:parallel`
* `:cache`

See below for more information.

### Configuring HTML validation rules

If `check_html` is `true`, Nokogiri performs additional validation on your HTML.

You can pass in additional options to configure this validation.

| Option | Description | Default |
| :----- | :---------- | :------ |
| `report_invalid_tags` | When `check_html` is enabled, HTML markup that is unknown to Nokogiri are reported as errors. | `false`
| `report_missing_names` | When `check_html` is enabled, HTML markup that are missing entity names are reported as errors. | `false`
| `report_script_embeds` | When `check_html` is enabled, `script` tags containing markup [are reported as errors](http://git.io/vOovv). Enabling this option ignores those errors. | `false`

For example:

``` ruby
opts = { :check_html => true, :validation => { :report_script_embeds => true } }
```

### Configuring Typhoeus and Hydra

[Typhoeus](https://github.com/typhoeus/typhoeus) is used to make fast, parallel requests to external URLs. You can pass in any of Typhoeus' options for the external link checks with the options namespace of `:typhoeus`. For example:

``` ruby
HTMLProofer.new("out/", {:extension => ".htm", :typhoeus => { :verbose => true, :ssl_verifyhost => 2 } })
```

This sets `HTMLProofer`'s extensions to use _.htm_, gives Typhoeus a configuration for it to be verbose, and use specific SSL settings. Check the [Typhoeus documentation](https://github.com/typhoeus/typhoeus#other-curl-options) for more information on what options it can receive.

You can similarly pass in a `:hydra` option with a hash configuration for Hydra.

The default value is:

``` ruby
{
  :typhoeus =>
  {
    :followlocation => true,
    :connecttimeout => 10,
    :timeout => 30
  },
  :hydra => { :max_concurrency => 50 }
}
```

### Configuring Parallel

[Parallel](https://github.com/grosser/parallel) can be used to speed internal file checks. You can pass in any of its options with the options namespace `:parallel`. For example:

``` ruby
HTMLProofer.check_directories(["out/"], {:extension => ".htm", :parallel => { :in_processes => 3} })
```

In this example, `:in_processes => 3` is passed into Parallel as a configuration option.

## Configuring caching

Checking external URLs can slow your tests down. If you'd like to speed that up, you can enable caching for your external links. Caching simply means to skip links that are valid for a certain period of time.

You can enable caching for this log file by passing in the option `:cache`, with a hash containing a single key, `:timeframe`. `:timeframe` defines the length of time the cache will be used before the link is checked again. The format of `:timeframe` is a number followed by a letter indicating the length of time. For example:

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

You can change the directory where the cachefile is kept by also providing the `storage_dir` key:

``` ruby
{ :cache => { :storage_dir => '/tmp/html-proofer-cache-money' } }
```

Links that were failures are kept in the cache and *always* rechecked. If they pass, the cache is updated to note the new timestamp.

The cache operates on external links only.

If caching is enabled, HTMLProofer writes to a log file called *tmp/.htmlproofer/cache.log*. You should probably ignore this folder in your version control system.

### Caching with Travis

If you want to enable caching with Travis CI, be sure to add these lines into your _.travis.yml_ file:

```
cache:
  directories:
  - $TRAVIS_BUILD_DIR/tmp/.htmlproofer
```

For more information on using HTML-Proofer with Travis CI, see [this wiki page](https://github.com/gjtorikian/html-proofer/wiki/Using-HTMLProofer-From-Ruby-and-Travis).

## Logging

HTML-Proofer can be as noisy or as quiet as you'd like. If you set the `:log_level` option, you can better define the level of logging.

## Custom tests

Want to write your own test? Sure, that's possible!

Just create a class that inherits from `HTMLProofer::Check`. This subclass must define one method called `run`. This is called on your content, and is responsible for performing the validation on whatever elements you like. When you catch a broken issue, call `add_issue(message, line: line, content: content)` to explain the error. `line` refers to the line numbers, and `content` is the node content of the broken element.

If you're working with the element's attributes (as most checks do), you'll also want to call `create_element(node)` as part of your suite. This constructs an object that contains all the attributes of the HTML element you're iterating on.

Here's an example custom test demonstrating these concepts. It reports `mailto` links that point to `octocat@github.com`:

``` ruby
class MailToOctocat < ::HTMLProofer::Check
  def mailto?
    return false if @link.data_proofer_ignore || @link.href.nil?
    @link.href.match /mailto/
  end

  def octocat?
    return false if @link.data_proofer_ignore || @link.href.nil?
    @link.href.match /octocat@github.com/
  end

  def run
    @html.css('a').each do |node|
      @link = create_element(node)
      line = node.line

      if mailto? && octocat?
        return add_issue("Don't email the Octocat directly!", line: line)
      end
    end
  end
end
```

See our [list of third-party custom classes](https://github.com/gjtorikian/html-proofer/wiki/Extensions-(custom-classes)) and add your own to this list.

## Troubleshooting

Here are some brief snippets identifying some common problems that you can work around. For more information, check out [our wiki](https://github.com/gjtorikian/html-proofer/wiki).

[Our wiki page](https://github.com/gjtorikian/html-proofer/wiki/Using-HTMLProofer-From-Ruby-and-Travis) on using HTML-Proofer with Travis CI might also be useful.

### Ignoring SSL certificates

To ignore SSL certificates, turn off Typhoeus' SSL verification:

``` ruby
HTMLProofer.check_directory("out/", {
  :typhoeus => {
    :ssl_verifypeer => false,
    :ssl_verifyhost => 0}
}).run
```

### User-Agent

To change the User-Agent used by Typhoeus:

``` ruby
HTMLProofer.check_directory("out/", {
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

Project | Repository | Notes
:------ | :--------- | :----
[Jekyll's website](http://jekyllrb.com/) | [jekyll/jekyll](https://github.com/jekyll/jekyll) | A [separate script](https://github.com/jekyll/jekyll/blob/master/script/proof) calls `htmlproofer` and this used to be [called from Circle CI](https://github.com/jekyll/jekyll/blob/fdc0e33ebc9e4861840e66374956c47c8f5fcd95/circle.yml)
[Raspberry Pi's documentation](http://www.raspberrypi.org/documentation/) | [raspberrypi/documentation](https://github.com/raspberrypi/documentation)
[Squeak's website](http://squeak.org) | [squeak-smalltalk/squeak.org](https://github.com/squeak-smalltalk/squeak.org)
[Atom Flight Manual](http://flight-manual.atom.io) | [atom/flight-manual.atom.io](https://github.com/atom/flight-manual.atom.io)
[HTML Website Template](https://github.com/fulldecent/html-website-template) | [fulldecent/html-website-template](https://github.com/fulldecent/html-website-template) | A starting point for websites, uses [a Rakefile](https://github.com/fulldecent/html-website-template/blob/master/Rakefile) and [Travis configuration](https://github.com/fulldecent/html-website-template/blob/master/.travis.yml) to call [preconfigured testing](https://github.com/fulldecent/lightning-sites)
[Project Calico Documentation](http://docs.projectcalico.org) | [projectcalico/calico](https://github.com/projectcalico/calico) | Simple integration with Jekyll and Docker using a [Makefile](https://github.com/projectcalico/calico/blob/master/Makefile#L13)
