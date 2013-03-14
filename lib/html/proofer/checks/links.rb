# encoding: utf-8

module HTML::Proofer::Checks

  class Links < ::HTML::Proofer::Checks::Check
    def run
      @html.css('a').each do |a|
        href = a['href']

        if href && href.length > 0
          if href.include? '#'
            href_split = href.split('#')
          end
          if !external_href?(href)
            # an internal link, with a hash
            if href_split
              href_file = href_split[0]
              href_hash = href_split[1]

              # it's not an internal hash; it's pointing to some other file
              if href_file.length > 0
                href_location = File.join(File.dirname(@path), href_file)
                if !File.exist?(href_location)
                  self.add_issue("In #{@path}, internal link #{href_location} does not exist") 
                else
                  href_html = HTML::Proofer.create_nokogiri(href_location)
                  found_hash_match = false
                  unless href_html.search("[id=#{href_hash}]", "[name=#{href_hash}]").length > 0
                    self.add_issue("#{@path} is linking to #{href}, but #{href_hash} does not exist")
                  end
                end
              # it is an internal link, with an internal hash
              else
                unless @html.search("[id=#{href_hash}]", "[name=#{href_hash}]").length > 0
                  self.add_issue("#{@path} is linking to an internal hash called #{href_hash} that does not exist")
                end
              end
            # internal link, no hash
            else
              self.add_issue("#{@path} is linking to #{href}, which does not exist") unless File.exist?(File.join(File.dirname(@path), href))
            end
          else
            self.add_issue("#{@path} is linking to #{href}, which does not exist") unless validate_url(href)
          end
        else
          self.add_issue("In #{@path}, link has no href attribute")
        end
      end
    end
  end
end
