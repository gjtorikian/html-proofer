# encoding: utf-8

module HTML::Proofer::Checks

  class Images < ::HTML::Proofer::Checks::Check

    def run
      @html.css('img').each do |img|
        src = img['src']
        if src && src.length > 0
          if !src.match(/www/) && !src.match(/https?:/)
            self.add_issue("In #{@path}, image #{src} does not exist")
          else
            # external image
          end
        else
          self.add_issue("In #{@path}, image has no src attribute")
        end
      end
    end
  end
end
