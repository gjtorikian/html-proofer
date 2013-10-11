# encoding: utf-8

class Links < ::HTML::Proofer::Checks::Check

  def run
    @html.css('a').each do |a|
      href = a['href']

      if href && href.length > 0
        if @options[:href_swap]
          @options[:href_swap].each do |link, replace|
            href = href.gsub(link, replace)
          end
        end

        return if ignore_href?(href)

        if href.include? '#'
          href_split = href.split('#')
        end
        if !external_href?(href)

          # an internal link, with a hash
          if href_split && !href_split.empty?
            href_file = href_split[0]
            href_hash = href_split[1]

            # it's not an internal hash; it's pointing to some other file
            if href_file.length > 0
              if !file?(href_file)
                self.add_issue("#{@path}".blue + ": internal link #{href_file} does not exist")
              else
                href_html = HTML::Proofer.create_nokogiri(resolve_path(href_file))
                found_hash_match = false
                unless hash_check(href_html, href_hash)
                  self.add_issue("#{@path}".blue + ": linking to #{href}, but #{href_hash} does not exist")
                end
              end
            # it is an internal link, with an internal hash
            else
              unless hash_check(@html, href_hash)
                self.add_issue("#{@path}".blue + ": linking to an internal hash called #{href_hash} that does not exist")
              end
            end
          # internal link, no hash
          else
            self.add_issue("#{@path}".blue + ": internally linking to #{href}, which does not exist") unless file?(href)
          end
        else
          validate_url(href, "#{@path}".blue + ": externally linking to #{href}, which does not exist")
        end
      else
        self.add_issue("#{@path}".blue + ": link has no href attribute") unless a['name'] || a['id']
      end
    end
  end

  def hash_check(html, href_hash)
    html.xpath("//*[@id='#{href_hash}']", "//*[@name='#{href_hash}']").length > 0
  end

end
