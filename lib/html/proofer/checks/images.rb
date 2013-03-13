# encoding: utf-8

module HTML::Proofer::Checks

  class Images < ::HTML::Proofer::Checks::Check

    def run
      @html.css('img').each do |img|
        src = img['src']

        # check image sources
        if src && src.length > 0
          if !external_href?(src)
            self.add_issue("In #{@path}, internal image #{src} does not exist") unless src[0] != "/" and File.exist?(File.join(File.dirname(@path), src))
          else
            self.add_issue("In #{@path}, external image #{src} does not exist") unless validate_url(src)
          end
        else
          self.add_issue("In #{@path}, image has no src attribute")
        end

        # check alt tag
        self.add_issue("In #{@path}, image #{src} does not have an alt attribute") unless img['alt']
      end
    end
  end
end
