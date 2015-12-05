module HTML
  class Proofer
    class Configuration < Hash
      require_relative 'version'

      PROOFER_DEFAULTS = {
        :ext => '.html',
        :check_favicon => false,
        :href_swap => [],
        :href_ignore => [],
        :allow_hash_href => false,
        :file_ignore => [],
        :url_ignore => [],
        :check_external_hash => false,
        :alt_ignore => [],
        :empty_alt_ignore => false,
        :enforce_https => false,
        :disable_external => false,
        :verbose => false,
        :only_4xx => false,
        :directory_index_file => 'index.html',
        :check_html => false,
        :error_sort => :path,
        :checks_to_ignore => []
      }

      TYPHOEUS_DEFAULTS = {
        :followlocation => true,
        :headers => {
          'User-Agent' => "Mozilla/5.0 (compatible; HTML Proofer/#{HTML::Proofer::VERSION}; +https://github.com/gjtorikian/html-proofer)"
        }
      }

      HYDRA_DEFAULTS = {
        :max_concurrency => 50
      }
    end
  end
end
