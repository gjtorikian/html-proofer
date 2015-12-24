class HTMLProofer
  module Configuration
    require_relative 'version'

    PROOFER_DEFAULTS = {
      :allow_hash_href => false,
      :alt_ignore => [],
      :check_external_hash => false,
      :check_favicon => false,
      :check_html => false,
      :checks_to_ignore => [],
      :directory_index_file => 'index.html',
      :disable_external => false,
      :empty_alt_ignore => false,
      :enforce_https => false,
      :error_sort => :path,
      :ext => '.html',
      :external_only => false,
      :file_ignore => [],
      :http_status_ignore => [],
      :only_4xx => false,
      :url_ignore => [],
      :url_swap => [],
      :verbose => false
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
      :ignore_script_embeds => false
    }

    CACHE_DEFAULTS = {
      :timeframe => '30d'
    }

    def self.to_regex?(item)
      if item.start_with?('/') && item.end_with?('/')
        Regexp.new item[1...-1]
      else
        item
      end
    end
  end
end
