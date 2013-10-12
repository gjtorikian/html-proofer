# encoding: utf-8

class Link < ::HTML::Proofer::Checkable

  def href
    @href unless @href.nil? || @href.empty?
  end

  def missing_href?
    href.nil? and @name.nil? and @id.nil?
  end

end

class Links < ::HTML::Proofer::Checks::Check

  def run
    @html.css('a').each do |link|

      link = Link.new link, self
      return if link.ignore?

      # is there even a href?
      return self.add_issue("link has no href attribute") if link.missing_href?

      # is it even a valid URL?
      return self.add_issue "#{link.href} is an invalid URL" unless link.valid?

      # does the file even exist?
      if link.remote?
        validate_url link.href, "externally linking to #{link.href}, which does not exist"
      else
        self.add_issue "internally linking to #{link.href}, which does not exist" unless link.exists?
      end

      # verify the target hash
      if link.hash
        if link.remote?
          #not yet checked
        elsif link.internal?
          self.add_issue "linking to internal hash ##{link.hash} that does not exist" unless hash_check @html, link.hash
        elsif link.external?
          target_html = HTML::Proofer.create_nokogiri link.absolute_path
          self.add_issue "linking to #{link.href}, but #{link.hash} does not exist" unless hash_check target_html, link.hash
        end
      end
    end
  end

  def hash_check(html, href_hash)
    html.xpath("//*[@id='#{href_hash}']", "//*[@name='#{href_hash}']").length > 0
  end

end
