# From v3.x to v4.x

HTML-Proofer 4 has been fundamentally rewritten to address many problems, provide better expected defaults, and make it easier for future updates.

The biggest change is that the HTML parsing check has been removed. HTML parsers like Nokogumbo/Nokogiri, and indeed, many browsers, are fairly generous when it comes to accepting malformed HTML. This feature detected more false issues than actual ones.

You can also set your own custom reporter, to format results as you see fit. See the README for more info on how to do this.

Other changes include:

* Many of the configuration options have been renamed to be consistent. For example, `url_ignore` has become `ignore_urls`, and `url_swap` became `swap_urls`
* `alt_ignore` was removed; use `ignore_missing_alt` to ignore missing `alt` attributes, and `ignore_empty_alt` to ignore `alt` attributes that are empty (eg., `<img alt>` or `<img alt="">`)
* `check_favicon` and `check_opengraph` have been removed, as has `checks_to_ignore`. Pass in checks using the `checks` configuration option. See the README for more info.
* `check_img_http` was removed. All URLs are expected to be HTTPS; set `enforce_https` to `false` if you prefer keeping HTTP images around
* `external_only` was removed
* `file_ignore` was renamed to `ignore_files`
* `http_status_ignore` was renamed to `ignore_status_codes`
* `internal_domains` was removed; use `swap_urls` to prepend any necessary domain names
* Attributes can now be swapped with the `swap_attributes` option
* `typhoeus_config` and `hydra_config` have been renamed to just `typhoeus` and `hydra`
* Configuring the cache can now be down through the `cache` config option, rather than `timeframe` and `storage_dir`
* Parallel file processing is on by default
* Assuming extensions (`.html`) is enabled by default. Jekyll and other static sites use this.
* The cache is much more performant
