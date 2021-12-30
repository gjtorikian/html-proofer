# frozen_string_literal: true

module HTMLProofer
  module Configuration
    PROOFER_DEFAULTS = {
      allow_hash_href: true,
      allow_missing_href: false,
      alt_ignore: [],
      assume_extension: false,
      check_external_hash: false,
      check_favicon: false,
      check_img_http: false,
      check_opengraph: false,
      checks_to_ignore: [],
      check_sri: false,
      directory_index_file: 'index.html',
      disable_external: false,
      ignore_empty_mailto: false,
      ignore_missing_alt: false,
      enforce_https: true,
      error_sort: :path,
      extension: '.html',
      file_ignore: [],
      http_status_ignore: [],
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

    PARALLEL_DEFAULTS = {
      enable: true
    }.freeze

    CACHE_DEFAULTS = {}.freeze

    def self.generate_defaults(opts)
      options = PROOFER_DEFAULTS.merge(opts)

      options[:typhoeus] = HTMLProofer::Configuration::TYPHOEUS_DEFAULTS.merge(opts[:typhoeus] || {})
      options[:hydra] = HTMLProofer::Configuration::HYDRA_DEFAULTS.merge(opts[:hydra] || {})

      options[:parallel] = HTMLProofer::Configuration::PARALLEL_DEFAULTS.merge(opts[:parallel] || {})
      options[:cache] = HTMLProofer::Configuration::CACHE_DEFAULTS.merge(opts[:cache] || {})

      # TODO: make sure user can't add own src
      options.delete(:src)

      options
    end

    def self.to_regex?(item)
      if item.start_with?('/') && item.end_with?('/')
        Regexp.new item[1...-1]
      else
        item
      end
    end

    def self.parse_json_option(option_name, config, symbolize_names: true)
      raise ArgumentError, 'Must provide an option name in string format.' unless option_name.is_a?(String)
      raise ArgumentError, 'Must provide an option name in string format.' if option_name.strip.empty?

      return {} if config.nil?

      raise ArgumentError, 'Must provide a JSON configuration in string format.' unless config.is_a?(String)

      return {} if config.strip.empty?

      begin
        JSON.parse(config, { symbolize_names: symbolize_names })
      rescue StandardError
        raise ArgumentError, "Option '#{option_name} did not contain valid JSON."
      end
    end
  end
end
