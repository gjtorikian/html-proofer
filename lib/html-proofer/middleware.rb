# frozen_string_literal: true

module HTMLProofer
  class Middleware

    class InvalidHtmlError < StandardError
      def initialize(failures)
        @failures = failures
      end

      def message
          "HTML Validation errors (skip by adding `?proofer-ignore` to URL): \n#{@failures.join("\n")}"
      end
    end

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

    def initialize(app)
      @app = app
    end

    HTML_SIGNATURE = [
      '<!DOCTYPE HTML',
      '<HTML',
      '<HEAD',
      '<SCRIPT',
      '<IFRAME',
      '<H1',
      '<DIV',
      '<FONT',
      '<TABLE',
      '<A',
      '<STYLE',
      '<TITLE',
      '<B',
      '<BODY',
      '<BR',
      '<P',
      '<!--'
    ]

    def call(env)
      result = @app.call(env)
      return result if env['REQUEST_METHOD'] != 'GET'
      return result if env['QUERY_STRING'] =~ /proofer-ignore/
      return result if result.first != 200
      body = []
      result.last.each { |e| body << e }

      body = body.join('')
      begin
        html = body.lstrip
      rescue
        return result # Invalid encoding; it's not gonna be html.
      end
      if HTML_SIGNATURE.any? { |sig| html.upcase.start_with? sig }
        parsed = HTMLProofer::Runner.new(
          'response',
          Middleware.options
        ).check_parsed(
          Nokogiri::HTML(Utils.clean_content(html)), 'response'
        )

        if parsed[:failures].length > 0
          raise InvalidHtmlError.new(parsed[:failures])
        end
      end
      result
    end
  end
end
