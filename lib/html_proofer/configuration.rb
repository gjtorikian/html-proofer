# frozen_string_literal: true

module HTMLProofer
  module Configuration
    DEFAULT_TESTS = ["Links", "Images", "Scripts"].freeze

    PROOFER_DEFAULTS = {
      allow_hash_href: true,
      allow_missing_href: false,
      assume_extension: ".html",
      check_external_hash: true,
      check_internal_hash: true,
      checks: DEFAULT_TESTS,
      directory_index_file: "index.html",
      disable_external: false,
      ignore_empty_alt: true,
      ignore_empty_mailto: false,
      ignore_files: [],
      ignore_missing_alt: false,
      ignore_status_codes: [],
      ignore_urls: [],
      enforce_https: true,
      extensions: [".html"],
      log_level: :info,
      only_4xx: false,
      swap_attributes: {},
      swap_urls: {},
    }.freeze

    TYPHOEUS_DEFAULTS = {
      followlocation: true,
      headers: {
        "User-Agent" => "Mozilla/5.0 (compatible; HTML Proofer/#{HTMLProofer::VERSION}; +https://github.com/gjtorikian/html-proofer)",
        "Accept" => "application/xml,application/xhtml+xml,text/html;q=0.9, text/plain;q=0.8,image/png,*/*;q=0.5",
      },
      connecttimeout: 10,
      timeout: 30,
    }.freeze

    HYDRA_DEFAULTS = {
      max_concurrency: 50,
    }.freeze

    PARALLEL_DEFAULTS = {
      enable: true,
    }.freeze

    CACHE_DEFAULTS = {}.freeze

    class << self
      def generate_defaults(opts)
        validate_options(default_options, opts)

        options = PROOFER_DEFAULTS.merge(opts)

        options[:typhoeus] = HTMLProofer::Configuration::TYPHOEUS_DEFAULTS.merge(opts[:typhoeus] || {})
        options[:hydra] = HTMLProofer::Configuration::HYDRA_DEFAULTS.merge(opts[:hydra] || {})

        options[:parallel] = HTMLProofer::Configuration::PARALLEL_DEFAULTS.merge(opts[:parallel] || {})
        options[:cache] = HTMLProofer::Configuration::CACHE_DEFAULTS.merge(opts[:cache] || {})

        options.delete(:src)

        options
      end

      def to_regex?(item)
        if item.start_with?("/") && item.end_with?("/")
          Regexp.new(item[1...-1])
        else
          item
        end
      end

      def parse_json_option(option_name, config, symbolize_names: true)
        raise ArgumentError, "Must provide an option name in string format." unless option_name.is_a?(String)
        raise ArgumentError, "Must provide an option name in string format." if option_name.strip.empty?

        return {} if config.nil?

        raise ArgumentError, "Must provide a JSON configuration in string format." unless config.is_a?(String)

        return {} if config.strip.empty?

        begin
          JSON.parse(config, { symbolize_names: symbolize_names })
        rescue StandardError
          raise ArgumentError, "Option '#{option_name} did not contain valid JSON."
        end
      end

      private

      def default_options
        PROOFER_DEFAULTS.merge(typhoeus: TYPHOEUS_DEFAULTS).merge(hydra: HYDRA_DEFAULTS).merge(parallel: PARALLEL_DEFAULTS)
      end

      def validate_options(defaults, options)
        defaults.each do |key, default_value|
          next unless options.key?(key)

          value = options[key]
          raise TypeError, "Invalid value for '#{key}': '#{value}'. Expected #{default_value.class}." unless value.is_a?(default_value.class)

          # Iterate over nested hashes
          validate_options(default_value, value) if default_value.is_a?(Hash)
        end
      end
    end
  end
end
