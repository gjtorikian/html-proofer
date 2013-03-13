# encoding: utf-8   

module HTML::Proofer::Checks

  class Images < ::HTML::Proofer::Checks::Check

    def run
      @html.css('img').each do |img|
        src = img['src']
        if src
          if !src.match(/www/) && !src.match(/https?:/)
            self.add_issue("In #{@path}, image #{src} does not exist")
          else
            # external image
          end
        end
      end
    end
  end
end
