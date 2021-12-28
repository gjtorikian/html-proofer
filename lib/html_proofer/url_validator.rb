# frozen_string_literal: true

module HTMLProofer
  class UrlValidator
    include HTMLProofer::Utils

    def initialize(runner)
      @runner = runner
    end

    # def handle_hash
    #   if @url.internal? && !hash_exists?(link.html, link.hash)

    #   elsif link.external?
    #     return external_link_check(link, line, content)
    #   end

    #   true
    # end
  end
end
