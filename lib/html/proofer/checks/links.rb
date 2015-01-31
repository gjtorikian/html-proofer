# encoding: utf-8
class LinkCheckable < ::HTML::Proofer::Checkable

  def href
    real_attr @href
  end

  def id
    real_attr @id
  end

  def name
    real_attr @name
  end

  def missing_href?
    href.nil? && name.nil? && id.nil?
  end

  def placeholder?
    (id || name) && href.nil?
  end

end

class LinkCheck < ::HTML::Proofer::CheckRunner
  include HTML::Utils

  def run
    @html.css('a, link').each do |l|
      link = LinkCheckable.new l, self

      next if link.ignore?
      next if link.href =~ /^javascript:/ # can't put this in ignore? because the URI does not parse
      next if link.placeholder?

      # is it even a valid URL?
      unless link.valid?
        add_issue("#{link.href} is an invalid URL", l.line)
        next
      end

      if link.scheme == 'mailto'
        add_issue("#{link.href} contains no email address", l.line) if link.path.empty?
        add_issue("#{link.href} contain an invalid email address", l.line) unless link.path.include?('@')
      end

      if link.scheme == 'tel'
        add_issue("#{link.href} contains no phone number", l.line) if link.path.empty?
      end

      # is there even a href?
      if link.missing_href?
        add_issue('anchor has no href attribute', l.line)
        next
      end

      # intentionally here because we still want valid? & missing_href? to execute
      next if link.non_http_remote?

      # does the file even exist?
      if link.remote?
        add_to_external_urls link.href
        next
      elsif !link.internal?
        add_issue("internally linking to #{link.href}, which does not exist", l.line) unless link.exists?
      end

      # does the local directory have a trailing slash?
      if link.unslashed_directory? link.absolute_path
        add_issue("internally linking to a directory #{link.absolute_path} without trailing slash", l.line)
        next
      end

      # verify the target hash
      if link.hash
        if link.internal?
          unless hash_check @html, link.hash
            add_issue("linking to internal hash ##{link.hash} that does not exist", l.line)
          end
        elsif link.external?
          external_link_check(link)
        end
      end
    end

    external_urls
  end

  def external_link_check(link)
    if !link.exists?
      add_issue("trying to find hash of #{link.href}, but #{link.absolute_path} does not exist", link.line)
    else
      target_html = create_nokogiri link.absolute_path
      unless hash_check target_html, link.hash
        add_issue("linking to #{link.href}, but #{link.hash} does not exist", link.line)
      end
    end
  end

  def hash_check(html, href_hash)
    html.xpath("//*[@id='#{href_hash}']", "//*[@name='#{href_hash}']").length > 0
  end

end
