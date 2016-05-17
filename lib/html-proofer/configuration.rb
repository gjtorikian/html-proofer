module HTMLProofer
  module Configuration
    require_relative 'version'

    PROOFER_DEFAULTS = {
      :allow_hash_href => false,
      :alt_ignore => [],
      :assume_extension => false,
      :check_external_hash => false,
      :check_favicon => false,
      :check_html => false,
      :checks_to_ignore => [],
      :directory_index_file => 'index.html',
      :disable_external => false,
      :empty_alt_ignore => false,
      :enforce_https => false,
      :error_sort => :path,
      :extension => '.html',
      :external_only => false,
      :file_ignore => [],
      :http_status_ignore => [],
      :log_level => :info,
      :only_4xx => false,
      :url_ignore => [],
      :url_swap => []
    }

    TYPHOEUS_DEFAULTS = {
      :followlocation => true,
      :headers => {
        'User-Agent' => "Mozilla/5.0 (compatible; HTML Proofer/#{HTMLProofer::VERSION}; +https://github.com/gjtorikian/html-proofer)"
      }
    }

    HYDRA_DEFAULTS = {
      :max_concurrency => 50
    }

    PARALLEL_DEFAULTS = {}

    VALIDATION_DEFAULTS = {
      :report_script_embeds => false,
      :report_missing_names => false,
      :report_invalid_tags => false
    }

    CACHE_DEFAULTS = {}

    def self.to_regex?(item)
      if item.start_with?('/') && item.end_with?('/')
        Regexp.new item[1...-1]
      else
        item
      end
    end
  end
end
