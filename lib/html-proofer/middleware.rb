

module HTMLProofer
  class Middleware

    def self.options
      @options ||= {
        type:                :file,
        allow_missing_href:  true, # Permitted in html5
        allow_hash_href:     true,
        check_external_hash: true,
        check_html:          true,
        url_ignore:          [/.*/], # Don't try to check local files exist
      }
    end

    def initialize app
      @app = app
    end

    HTML_SIGNATURE = [
      "<!DOCTYPE HTML",
      "<HTML",
      "<HEAD",
      "<SCRIPT",
      "<IFRAME",
      "<H1",
      "<DIV",
      "<FONT",
      "<TABLE",
      "<A",
      "<STYLE",
      "<TITLE",
      "<B",
      "<BODY",
      "<BR",
      "<P",
      "<!--"
    ]

    def call env
      result = @app.call(env)
      return result if env["REQUEST_METHOD"] != "GET"
      return result if env["QUERY_STRING"] =~ /SKIP_VALIDATION/
      return result if result.first != 200

      # [@status, @headers, @response]
      html = result.last.each.to_a.join('').lstrip
      if HTML_SIGNATURE.any? {|sig| html.downcase.starts_with? sig.downcase}
        parsed = HTMLProofer::Runner.new(
          'response',
          Middleware.options
        ).check_parsed(
          Nokogiri::HTML(Utils.clean_content(html)), 'response'
        )

        if parsed[:failures].length > 0
          raise "HTML Validation errors (skip by adding ?SKIP_VALIDATION to URL): \n#{parsed[:failures].join("\n")}"
        end
      end
      result
    end
  end
end

