# HTMLProofer

If you generate HTML files, _then this tool might be for you_!

## Project scope

HTMLProofer is a set of tests to validate your HTML output. These tests check if your image references are legitimate, if they have alt tags, if your internal links are working, and so on. It's intended to be an all-in-one checker for your output.

In scope for this project is any well-known and widely-used test for HTML document quality. A major use for this project is continuous integration -- so we must have reliable results. We usually balance correctness over performance. And, if necessary, we should be able to trace this program's detection of HTML errors back to documented best practices or standards, such as W3 specifications.

**Third-party modules.** We want this product to be useful for continuous integration so we prefer to avoid subjective tests which are prone to false positive results, such as spell checkers, indentation checkers, etc. If you want to work on these items, please see [the section on custom tests](#custom-tests) and consider adding an implementation as a third-party module.

**Advanced configuration.** Most front-end developers can test their HTML using [our command line program](#using-on-the-command-line). Advanced configuration will require using Ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'html-proofer'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install html-proofer

**NOTE:** When installation speed matters, set `NOKOGIRI_USE_SYSTEM_LIBRARIES` to `true` in your environment. This is useful for increasing the speed of your Continuous Integration builds.

## What's tested?

Below is a mostly comprehensive list of checks that HTMLProofer can perform.

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

## Usage

You can configure HTMLProofer to run on:

* a file
* a directory
* an array of directories
* an array of links

It can also run through the command-line.

### Using in a script

1. Require the gem.
2. Generate some HTML.
3. Create a new instance of the `HTMLProofer` on your output folder.
4. Call `proofer.run` on that path.

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
], gfm: true

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
HTMLProofer.check_links(['https://github.com', 'https://jekyllrb.com']).run
```

### Swapping information

Sometimes, the information in your HTML is not the same as how your server serves content. In these cases, you can use `swap_urls` to map the URL in a file to the URL you'd like it to become. For example:

```ruby
run_proofer(file, :file, swap_urls: { %r{^https//example.com}: 'https://website.com' })
```

In this case, any link that matches the `^https://example.com` will be converted to `https://website.com`.

A similar swapping process can be done for attributes:

```ruby
run_proofer(file, :file, swap_urls: { 'img': [['src', 'srcset']] })
```

In this case, we are telling HTMLProofer that, for any `img` tag detected, and for any check using the `src` attribute, to use the `srcset` attribute instead. Since the value is an array of arrays, you can pass in as many attribute swaps as you need.

### Using on the command-line

You'll also get a new program called `htmlproofer` with this gem. Terrific!

Pass in options through the command-line as flags, like this:

``` bash
htmlproofer --extensions .html.erb ./out
```

Use `htmlproofer --help` to see all command line options, or [take a peek here](https://github.com/gjtorikian/html-proofer/blob/main/bin/htmlproofer).

#### Special cases for the command-line

For options which require an array of input, surround the value with quotes, and don't use
any spaces. For example, to exclude an array of HTTP status code, you might do:

``` bash
htmlproofer --ignore-status-codes "999,401,404" ./out
```

For something like `url-ignore`, and other options that require an array of regular expressions,
you can pass in a syntax like this:

``` bash
htmlproofer --ignore-urls "/www.github.com/,/foo.com/" ./out
```

Since `swap_urls` is a bit special, you'll pass in a pair of `RegEx:String`
values. The escape sequences `\:` should be used to produce literal
`:`s `htmlproofer` will figure out what you mean.

``` bash
htmlproofer --swap-urls "wow:cow,mow:doh" --extensions .html.erb --ignore-urls www.github.com ./out
```

Some configuration options--such as `--typheous`, `--cache`, or `--attribute-swap`--require well-formatted JSON.

#### Adjusting for a `baseurl`

If your Jekyll site has a `baseurl` configured, you'll need to adjust the
generated url validation to cope with that. The easiest way is using the
`swap_urls` option.

For a `site.baseurl` value of `/BASEURL`, here's what that looks like on the
command line:

```bash
htmlproofer --assume-extension ./_site --swap-urls '^/BASEURL/:/'
```

or in your `Rakefile`

```ruby
require 'html-proofer'

task :test do
  sh "bundle exec jekyll build"
  options = { swap_urls: "^/BASEURL/:/" }
  HTMLProofer.check_directory("./_site", options).run
end
```

### Using through Docker

If you have trouble with (or don't want to) install Ruby/Nokogumbo, the command-line tool can be run through Docker. See [klakegg/html-proofer](https://hub.docker.com/r/klakegg/html-proofer) for more information.


## Ignoring content

Add the `data-proofer-ignore` attribute to any tag to ignore it from every check.

``` html
<a href="https://notareallink" data-proofer-ignore>Not checked.</a>
```

This can also apply to parent elements, all the way up to the `<html>` tag:

``` html
<div data-proofer-ignore>
  <a href="https://notareallink">Not checked because of parent.</a>
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

  HTMLProofer.check_directory('./output', { ignore_urls: diffable_files }).run
```

## Configuration

The `HTMLProofer` constructor takes an optional hash of additional options:

| Option | Description | Default |
| :----- | :---------- | :------ |
| `allow_hash_href` | If `true`, assumes `href="#"` anchors are valid | `true` |
| `allow_missing_href` | If `true`, does not flag `a` tags missing `href`. In HTML5, this is technically allowed, but could also be human error. | `false` |
| `assume_extension` | Automatically add specified extension to files for internal links, to allow extensionless URLs (as supported by most servers) | `.html` |
| `checks`| An array of Strings indicating which checks you want to run | `['Links', 'Images', 'Scripts']`
| `check_external_hash` | Checks whether external hashes exist (even if the webpage exists) | `true` |
| `check_internal_hash` | Checks whether internal hashes exist (even if the webpage exists) | `true` |
| `check_sri` | Check that `<link>` and `<script>` external resources use SRI |false |
| `directory_index_file` | Sets the file to look for when a link refers to a directory. | `index.html` |
| `disable_external` | If `true`, does not run the external link checker | `false` |
| `enforce_https` | Fails a link if it's not marked as `https`. | `true` |
| `extensions` | An array of Strings indicating the file extensions you would like to check (including the dot) | `['.html']`
| `ignore_empty_alt` | If `true`, ignores images with empty/missing alt tags (in other words, `<img alt>` and `<img alt="">` are valid; set this to `false` to flag those) | `true` |
| `ignore_files` | An array of Strings or RegExps containing file paths that are safe to ignore. | `[]` |
| `ignore_empty_mailto` | If `true`, allows `mailto:` `href`s which do not contain an email address. | `false`
| `ignore_missing_alt` | If `true`, ignores images with missing alt tags | `false` |
| `ignore_status_codes` | An array of numbers representing status codes to ignore. | `[]`
| `ignore_urls` | An array of Strings or RegExps containing URLs that are safe to ignore. This affects all HTML attributes, such as `alt` tags on images. | `[]` |
| `log_level` | Sets the logging level, as determined by [Yell](https://github.com/rudionrails/yell). One of `:debug`, `:info`, `:warn`, `:error`, or `:fatal`. | `:info`
| `only_4xx` | Only reports errors for links that fall within the 4xx status code range. | `false` |
| `root_dir` | The absolute path to the directory serving your html-files. | "" |
| `swap_attributes` | JSON-formatted config that maps element names to the preferred attribute to check | `{}` |
| `swap_urls` | A hash containing key-value pairs of `RegExp => String`. It transforms URLs that match `RegExp` into `String` via `gsub`. | `{}` |

In addition, there are a few "namespaced" options. These are:

* `:typhoeus` / `:hydra`
* `:parallel`
* `:cache`

### Configuring Typhoeus and Hydra

[Typhoeus](https://github.com/typhoeus/typhoeus) is used to make fast, parallel requests to external URLs. You can pass in any of Typhoeus' options for the external link checks with the options namespace of `:typhoeus`. For example:

``` ruby
HTMLProofer.new("out/", {extensions: [".htm"], typhoeus: { verbose: true, ssl_verifyhost: 2 } })
```

This sets `HTMLProofer`'s extensions to use _.htm_, gives Typhoeus a configuration for it to be verbose, and use specific SSL settings. Check the [Typhoeus documentation](https://github.com/typhoeus/typhoeus#other-curl-options) for more information on what options it can receive.

You can similarly pass in a `:hydra` option with a hash configuration for Hydra.

The default value is:

``` ruby
{
  typhoeus:
  {
    followlocation: true,
    connecttimeout: 10,
    timeout: 30
  },
  hydra: { max_concurrency: 50 }
}
```

On the CLI, you can provide the `--typhoeus` or `hydra` arguments to set the configurations. This is parsed using `JSON.parse` and mapped on top of the default configuration values so that they can be overridden.

#### Setting `before-request` callback

You can provide a block to set some logic before an external link is checked. For example, say you want to provide an authentication token every time a GitHub URL is checked. You can do that like this:

```ruby
proofer = HTMLProofer.check_directory(item, opts)
proofer.before_request do |request|
  request.options[:headers]['Authorization'] = "Bearer <TOKEN>" if request.base_url == "https://github.com"
end
proofer.run
```

The `Authorization` header is being set if and only if the `base_url` is `https://github.com`, and it is excluded for all other URLs.

### Configuring Parallel

[Parallel](https://github.com/grosser/parallel) is used to speed internal file checks. You can pass in any of its options with the options namespace `:parallel`. For example:

``` ruby
HTMLProofer.check_directories(["out/"], {extension: ".htm", parallel: { in_processes: 3} })
```

In this example, `in_processes: 3` is passed into Parallel as a configuration option.

Pass in `parallel: { enable: false }` to disable parallel runs.

On the CLI, you can provide the `--parallel` argument to set the configuration. This is parsed using `JSON.parse` and mapped on top of the default configuration values so that they can be overridden.

## Configuring caching

Checking external URLs can slow your tests down. If you'd like to speed that up, you can enable caching for your external and internal links. Caching simply means to skip link checking for links that are valid for a certain period of time.

You can enable caching for this by passing in the configuration option `:cache`, with a hash containing a single key, `:timeframe`. `:timeframe` defines the length of time the cache will be used before the link is checked again. The format of `:timeframe` is a hash containing two keys, `external` and `internal`. Each of these contains a number followed by a letter indicating the length of time:

* `M` means months
* `w` means weeks
* `d` means days
* `h` means hours

For example, passing the following options means "recheck external links older than thirty days":

``` ruby
{ cache: { timeframe: { external: '30d' } } }
```

And the following options means "recheck internal links older than two weeks":

``` ruby
{ cache: { timeframe: { internal: '2w' } } }
```

Naturally, to support both internal and external link caching, both keys would need to be provided. The following checks external links every two weeks, but internal links only once a week:

``` ruby
{ cache: { timeframe: { external: '2w', internal: '1w' } } }
```

You can change the filename or the directory where the cache file is kept by also providing the `storage_dir` key:

``` ruby
{ cache: { cache_file: 'stay_cachey.json', storage_dir: '/tmp/html-proofer-cache-money' } }
```

Links that were failures are kept in the cache and *always* rechecked. If they pass, the cache is updated to note the new timestamp.

The cache operates on external links only.

If caching is enabled, HTMLProofer writes to a log file called *tmp/.htmlproofer/cache.log*. You should probably ignore this folder in your version control system.

On the CLI, you can provide the `--cache` argument to set the configuration. This is parsed using `JSON.parse` and mapped on top of the default configuration values so that they can be overridden.

### Caching with continuous integration

Enable caching in your continuous integration process. It will make your builds faster.

**In GitHub Actions:**

Add this step to your build workflow before HTMLProofer is run:

```yaml
      - name: Cache HTMLProofer
        id: cache-htmlproofer
        uses: actions/cache@v2
        with:
          path: tmp/.htmlproofer
          key: ${{ runner.os }}-htmlproofer
```

Also make sure that your later step which runs HTMLProofer will not return a failed shell status. You can try something like `html-proof ... || true`. Because a failed step in GitHub Actions will skip all later steps.

**In Travis:**

If you want to enable caching with Travis CI, be sure to add these lines into your _.travis.yml_ file:

```yaml
cache:
  directories:
  - $TRAVIS_BUILD_DIR/tmp/.htmlproofer
```

For more information on using HTML-Proofer with Travis CI, see [this wiki page](https://github.com/gjtorikian/html-proofer/wiki/Using-HTMLProofer-From-Ruby-and-Travis).

## Logging

HTML-Proofer can be as noisy or as quiet as you'd like. If you set the `:log_level` option, you can better define the level of logging.

## Custom tests

Want to write your own test? Sure, that's possible!

Just create a class that inherits from `HTMLProofer::Check`. This subclass must define one method called `run`. This is called on your content, and is responsible for performing the validation on whatever elements you like. When you catch a broken issue, call `add_failure(message, line: line, content: content)` to explain the error. `line` refers to the line numbers, and `content` is the node content of the broken element.

If you're working with the element's attributes (as most checks do), you'll also want to call `create_element(node)` as part of your suite. This constructs an object that contains all the attributes of the HTML element you're iterating on.

Here's an example custom test demonstrating these concepts. It reports `mailto` links that point to `octocat@github.com`:

``` ruby
class MailToOctocat < ::HTMLProofer::Check
  def mailto_octocat?
    @link.url.raw_attribute == 'mailto:octocat@github.com'
  end

  def run
    @html.css('a').each do |node|
      @link = create_element(node)

      next if @link.ignore?

      return add_failure("Don't email the Octocat directly!", line: @link.line) if mailto_octocat?
    end
  end
end
```

Don't forget to include this new check in HTMLProofer's options, for example:

```ruby
# removes default checks and just runs this one
HTMLProofer.check_directories(["out/"], {checks: ['MailToOctocat']})
```

See our [list of third-party custom classes](https://github.com/gjtorikian/html-proofer/wiki/Extensions-(custom-classes)) and add your own to this list.

## Reporting

By default, HTML-Proofer has its own reporting mechanism to print errors at the end of the run. You can choose to use your own reporter by passing in your own subclass of `HTMLProofer::Reporter`:

``` ruby
proofer = HTMLProofer.check_directory(item, opts)
proofer.reporter = MyCustomReporter.new(logger: proofer.logger)
proofer.run
```

Your custom reporter must implement the `report` function which implements the behavior you wish to see. The `logger` kwarg is optional.

## Troubleshooting

Here are some brief snippets identifying some common problems that you can work around. For more information, check out [our wiki](https://github.com/gjtorikian/html-proofer/wiki).

[Our wiki page](https://github.com/gjtorikian/html-proofer/wiki/Using-HTMLProofer-From-Ruby-and-Travis) on using HTML-Proofer with Travis CI might also be useful.

### Ignoring SSL certificates

To ignore SSL certificates, turn off Typhoeus' SSL verification:

``` ruby
HTMLProofer.check_directory("out/", {
  typhoeus: {
    ssl_verifypeer: false,
    ssl_verifyhost: 0}
}).run
```

### User-Agent

To change the User-Agent used by Typhoeus:

``` ruby
HTMLProofer.check_directory("out/", {
  typhoeus: {
    headers: { "User-Agent" => "Mozilla/5.0 (compatible; My New User-Agent)" }
}}).run
```

Alternatively, you can specifify these options on the commandline with:

```bash
htmlproofer --typhoeus-config='{"headers":{"User-Agent":"Mozilla/5.0 (compatible; My New User-Agent)"}}'
```

### Cookies

Sometimes links fail because they don't have access to cookies. To fix this you can create a .cookies file using the following snippets:

``` ruby
HTMLProofer.check_directory("out/", {
  typhoeus: {
    cookiefile: ".cookies",
    cookiejar: ".cookies"
}}).run
```

```bash
htmlproofer --typhoeus-config='{"cookiefile":".cookies","cookiejar":".cookies"}'
```

### Regular expressions

To exclude urls using regular expressions, include them between forward slashes and don't quote them:

``` ruby
HTMLProofer.check_directories(["out/"], {
  ignore_urls: [/example.com/],
}).run
```

## Real-life examples

Project | Repository | Notes
:------ | :--------- | :----
[Jekyll's website](https://jekyllrb.com/) | [jekyll/jekyll](https://github.com/jekyll/jekyll) | A [separate script](https://github.com/jekyll/jekyll/blob/master/script/proof) calls `htmlproofer` and this used to be [called from Circle CI](https://github.com/jekyll/jekyll/blob/fdc0e33ebc9e4861840e66374956c47c8f5fcd95/circle.yml)
[Raspberry Pi's documentation](https://www.raspberrypi.org/documentation/) | [raspberrypi/documentation](https://github.com/raspberrypi/documentation)
[Squeak's website](https://squeak.org) | [squeak-smalltalk/squeak.org](https://github.com/squeak-smalltalk/squeak.org)
[Atom Flight Manual](https://flight-manual.atom.io) | [atom/flight-manual.atom.io](https://github.com/atom/flight-manual.atom.io)
[HTML Website Template](https://github.com/fulldecent/html-website-template) | [fulldecent/html-website-template](https://github.com/fulldecent/html-website-template) | A starting point for websites, uses [a Rakefile](https://github.com/fulldecent/html-website-template/blob/master/Rakefile) and [Travis configuration](https://github.com/fulldecent/html-website-template/blob/master/.travis.yml) to call [preconfigured testing](https://github.com/fulldecent/lightning-sites)
[Project Calico Documentation](https://docs.projectcalico.org) | [projectcalico/calico](https://github.com/projectcalico/calico) | Simple integration with Jekyll and Docker using a [Makefile](https://github.com/projectcalico/calico/blob/master/Makefile#L13)
[GitHub does dotfiles](https://dotfiles.github.io/) | [dotfiles/dotfiles.github.com](https://github.com/dotfiles/dotfiles.github.com) | Uses the [proof-html](https://github.com/marketplace/actions/proof-html) GitHub action
