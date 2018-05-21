module HTMLProofer
  module Configuration
    require_relative 'version'

    PROOFER_DEFAULTS = {
      allow_missing_href: false,
      allow_hash_href: false,
      alt_ignore: [],
      assume_extension: false,
      check_external_hash: false,
      check_favicon: false,
      check_html: false,
      check_img_http: false,
      check_opengraph: false,
      checks_to_ignore: [],
      check_sri: false,
      directory_index_file: 'index.html',
      disable_external: false,
      empty_alt_ignore: false,
      enforce_https: false,
      error_sort: :path,
      extension: '.html',
      external_only: false,
      file_ignore: [],
      http_status_ignore: [],
      internal_domains: [],
      log_level: :info,
      only_4xx: false,
      url_ignore: [],
      url_swap: {}
    }.freeze

    TYPHOEUS_DEFAULTS = {
      followlocation: true,
      headers: {
        'User-Agent' => "Mozilla/5.0 (compatible; HTML Proofer/#{HTMLProofer::VERSION}; +https://github.com/gjtorikian/html-proofer)",
        'Accept' => 'application/xml,application/xhtml+xml,text/html;q=0.9, text/plain;q=0.8,image/png,*/*;q=0.5'
      },
      connecttimeout: 10,
      timeout: 30
    }.freeze

    HYDRA_DEFAULTS = {
      max_concurrency: 50
    }.freeze

    PARALLEL_DEFAULTS = {}.freeze

    VALIDATION_DEFAULTS = {
      report_script_embeds: false,
      report_missing_names: false,
      report_invalid_tags: false
    }.freeze

    CACHE_DEFAULTS = {}.freeze

    def self.to_regex?(item)
      if item.start_with?('/') && item.end_with?('/')
        Regexp.new item[1...-1]
      else
        item
      end
    end
  end
end
