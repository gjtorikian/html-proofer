# frozen_string_literal: true

require "optparse"

module HTMLProofer
  class Configuration
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

    CACHE_DEFAULTS = {}.freeze

    class << self
      def generate_defaults(opts)
        options = PROOFER_DEFAULTS.merge(opts)

        options[:typhoeus] = HTMLProofer::Configuration::TYPHOEUS_DEFAULTS.merge(opts[:typhoeus] || {})
        options[:hydra] = HTMLProofer::Configuration::HYDRA_DEFAULTS.merge(opts[:hydra] || {})

        options[:cache] = HTMLProofer::Configuration::CACHE_DEFAULTS.merge(opts[:cache] || {})

        options.delete(:src)

        options
      end
    end

    def initialize
      @options = {}
    end

    def parse_cli_options(args)
      define_options.parse!(args)

      input = ARGV.empty? ? "." : ARGV.join(",")

      [@options, input]
    end

    private def define_options
      OptionParser.new do |opts|
        opts.banner = "Usage: htmlproofer [options] PATH/LINK"

        section(opts, "Input Options") do
          set_option(opts, "--as-links") do |long_opt_symbol, arg|
            @options[long_opt_symbol] = arg
          end

          set_option(opts, "--assume-extension EXT") do |long_opt_symbol, arg|
            @options[long_opt_symbol] = arg
          end

          set_option(opts, "--directory-index-file FILENAME") do |long_opt_symbol, arg|
            @options[long_opt_symbol] = arg
          end

          set_option(opts, "--extensions [EXT1,EXT2,...]") do |long_opt_symbol, list|
            @options[long_opt_symbol] = list.nil? ? [] : list.split(",")
          end
        end

        section(opts, "Check Configuration") do
          set_option(opts, "--[no-]allow-hash-href") do |long_opt_symbol, arg|
            @options[long_opt_symbol] = arg
          end

          set_option(opts, "--[no-]allow-missing-href") do |long_opt_symbol, arg|
            @options[long_opt_symbol] = arg
          end

          set_option(opts, "--checks [CHECK1,CHECK2,...]") do |long_opt_symbol, list|
            @options[long_opt_symbol] = list.nil? ? [] : list.split(",")
          end

          set_option(opts, "--[no-]check-external-hash") do |long_opt_symbol, arg|
            @options[long_opt_symbol] = arg
          end

          set_option(opts, "--[no-]check-internal-hash") do |long_opt_symbol, arg|
            @options[long_opt_symbol] = arg
          end

          set_option(opts, "--[no-]check-sri") do |long_opt_symbol, arg|
            @options[long_opt_symbol] = arg
          end

          set_option(opts, "--[no-]disable-external") do |long_opt_symbol, arg|
            @options[long_opt_symbol] = arg
          end

          set_option(opts, "--[no-]enforce-https") do |long_opt_symbol, arg|
            @options[long_opt_symbol] = arg
          end

          set_option(opts, "--root-dir <DIR>") do |long_opt_symbol, arg|
            @options[long_opt_symbol] = arg
          end
        end

        section(opts, "Ignore Configuration") do
          set_option(opts, "--ignore-files [FILE1,FILE2,...]") do |long_opt_symbol, list|
            @options[long_opt_symbol] = if list.nil?
              []
            else
              list.split(",").map.each do |l|
                if l.start_with?("/") && l.end_with?("/")
                  Regexp.new(l[1...-1])
                else
                  l
                end
              end
            end
          end

          set_option(opts, "--[no-]ignore-empty-alt") do |long_opt_symbol, arg|
            @options[long_opt_symbol] = arg
          end

          set_option(opts, "--[no-]ignore-empty-mailto") do |long_opt_symbol, arg|
            @options[long_opt_symbol] = arg
          end

          set_option(opts, "--[no-]ignore-missing-alt") do |long_opt_symbol, arg|
            @options[long_opt_symbol] = arg
          end

          set_option(opts, "--ignore-status-codes [500,401,420,...]") do |long_opt_symbol, list|
            @options[long_opt_symbol] = list.nil? ? [] : list.split(",").map(&:to_i)
          end

          set_option(opts, "--ignore-urls [URL1, URL2,...]") do |long_opt_symbol, list|
            @options[long_opt_symbol] = if list.nil?
              []
            else
              list.split(",").each_with_object([]) do |url, arr|
                arr << to_regex?(url)
              end
            end
          end

          set_option(opts, "--only-status-codes [404,451,...]") do |long_opt_symbol, list|
            @options[long_opt_symbol] = list.nil? ? [] : list.split(",")
          end

          set_option(opts, "--only-4xx") do |long_opt_symbol, arg|
            @options[long_opt_symbol] = arg
          end
        end

        section(opts, "Transforms Configuration") do
          set_option(opts, "--swap-attributes <CONFIG>") do |long_opt_symbol, arg|
            @options[long_opt_symbol] = parse_json_option("swap_attributes", arg, symbolize_names: false)
          end

          set_option(opts, "--swap-urls [re:string,re:string,...]") do |long_opt_symbol, arg|
            @options[long_opt_symbol] = str_to_regexp_map(arg)
          end
        end

        section(opts, "Dependencies Configuration") do
          set_option(opts, "--typhoeus <CONFIG>") do |long_opt_symbol, arg|
            @options[long_opt_symbol] = parse_json_option("typhoeus", arg, symbolize_names: false)
          end

          set_option(opts, "--hydra <CONFIG>") do |long_opt_symbol, arg|
            @options[long_opt_symbol] = parse_json_option("hydra", arg, symbolize_names: true)
          end

          set_option(opts, "--cache <CONFIG>") do |long_opt_symbol, arg|
            @options[long_opt_symbol] = parse_json_option("cache", arg, symbolize_names: true)
          end
        end

        section(opts, "Reporting Configuration") do
          set_option(opts, "--log-level <LEVEL>") do |long_opt_symbol, arg|
            @options[long_opt_symbol] = arg.to_sym
          end
        end

        section(opts, "General Configuration") do
          set_option(opts, "--version") do
            puts HTMLProofer::VERSION
            exit(0)
          end
        end
      end
    end

    private def to_regex?(item)
      if item.start_with?("/") && item.end_with?("/")
        Regexp.new(item[1...-1])
      else
        item
      end
    end

    private def str_to_regexp_map(arg)
      arg.split(",").each_with_object({}) do |s, hsh|
        split = s.split(/(?<!\\):/, 2)

        re = split[0].gsub("\\:", ":")
        string = split[1].gsub("\\:", ":")
        hsh[Regexp.new(re)] = string
      end
    end

    private def section(opts, heading, &_block)
      opts.separator("\n#{heading}:\n")
      yield
    end

    private def set_option(opts, long_arg, &block)
      long_opt_symbol = parse_long_opt(long_arg)
      args = []
      args += Array(ConfigurationHelp::TEXT[long_opt_symbol])

      opts.on(long_arg, *args) do |arg|
        yield long_opt_symbol, arg
      end
    end

    # Converts the option into a symbol,
    # e.g. '--allow-hash-href' => :allow_hash_href.
    private def parse_long_opt(long_opt)
      long_opt[2..].sub("[no-]", "").sub(/ .*/, "").tr("-", "_").gsub(/[\[\]]/, "").to_sym
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

    module ConfigurationHelp
      TEXT = {
        as_links: ["Assumes that `PATH` is a comma-separated array of links to check."],
        assume_extension: [
          "Automatically add specified extension to files for internal links, ",
          "to allow extensionless URLs (as supported by most servers) (default: `.html`).",
        ],
        directory_index_file: ["Sets the file to look for when a link refers to a directory. (default: `index.html`)."],
        extensions: [
          "A comma-separated list of Strings indicating the file extensions you",
          "would like to check (default: `.html`)",
        ],

        allow_hash_href: ['"If `true`, assumes `href="#"` anchors are valid (default: `true`)"'],
        allow_missing_href: [
          "If `true`, does not flag `a` tags missing `href`. In HTML5, this is technically ",
          "allowed, but could also be human error. (default: `false`)",
        ],
        checks: [
          "A comma-separated list of Strings indicating which checks you",
          "want to run (default: `[\"Links\", \"Images\", \"Scripts\"]",
        ],
        check_external_hash: ["Checks whether external hashes exist (even if the webpage exists) (default: `true`)."],
        check_internal_hash: ["Checks whether internal hashes exist (even if the webpage exists) (default: `true`)."],
        check_sri: ["Check that `<link>` and `<script>` external resources use SRI (default: `false`)."],
        disable_external: ["If `true`, does not run the external link checker (default: `false`)."],
        enforce_https: ["Fails a link if it's not marked as `https` (default: `true`)."],
        root_dir: ["The absolute path to the directory serving your html-files."],

        ignore_empty_alt: [
          "If `true`, ignores images with empty/missing ",
          "alt tags (in other words, `<img alt>` and `<img alt=\"\">`",
          "are valid; set this to `false` to flag those) (default: `true`).",
        ],
        ignore_empty_mailto: [
          "If `true`, allows `mailto:` `href`s which don't",
          "contain an email address (default: `false`)'.",
        ],
        ignore_missing_alt: ["If `true`, ignores images with missing alt tags (default: `false`)."],
        ignore_status_codes: ["A comma-separated list of numbers representing status codes to ignore."],
        ignore_files: ["A comma-separated list of Strings or RegExps containing file paths that are safe to ignore"],
        ignore_urls: [
          "A comma-separated list of Strings or RegExps containing URLs that are",
          "safe to ignore. This affects all HTML attributes, such as `alt` tags on images.",
        ],
        only_status_codes: ["A comma-separated list of numbers representing the only status codes to report on."],
        only_4xx: ["Only reports errors for links that fall within the 4xx status code range."],

        swap_attributes: [
          "JSON-formatted config that maps element names to the",
          "preferred attribute to check (default: `{}`).",
        ],
        swap_urls: [
          "A comma-separated list containing key-value pairs of `RegExp => String`.",
          "It transforms URLs that match `RegExp` into `String` via `gsub`.",
          "The escape sequences `\\:` should be used to produce literal `:`s.",
        ],

        typhoeus: ["JSON-formatted string of Typhoeus config; if set, overrides the html-proofer defaults."],
        hydra: ["JSON-formatted string of Hydra config; if set, overrides the html-proofer defaults."],
        cache: ["JSON-formatted string of cache config; if set, overrides the html-proofer defaults."],

        log_level: [
          "Sets the logging level. One of `:debug`, `:info`, ",
          "`:warn`, `:error`, or `:fatal`. (default: `:info`)",
        ],

        version: ["Prints the version of html-proofer."],
      }.freeze
    end
  end
end
