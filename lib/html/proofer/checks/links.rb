# encoding: utf-8

module HTML::Proofer::Checks

  class Links < ::HTML::Proofer::Checks::Check
    def run
      @html.css('a').each do |a|
        href = a['href']
        puts href
        if href && href.length > 0
          if !external_href?(href)
            
          else
            
          end
        else
          self.add_issue("In #{@path}, link has no href attribute")
        end
      end
    end
  end
end
