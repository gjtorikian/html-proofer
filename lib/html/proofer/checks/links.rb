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
  include HTML::Proofer::Utils

  def run
    @html.css('a, link').each do |node|
      link = LinkCheckable.new(node, self)
      line = node.line

      next if link.ignore?
      next if link.href =~ /^javascript:/ # can't put this in ignore? because the URI does not parse
      next if link.placeholder?

      # is it even a valid URL?
      unless link.valid?
        add_issue("#{link.href} is an invalid URL", line)
        next
      end

      check_schemes(link, line)

      # is there even a href?
      if link.missing_href?
        add_issue('anchor has no href attribute', line)
        next
      end

      # intentionally here because we still want valid? & missing_href? to execute
      next if link.non_http_remote?

      # does the file even exist?
      if link.remote?
        add_to_external_urls(link.href, line)
        next
      elsif !link.internal?
        add_issue("internally linking to #{link.href}, which does not exist", line) unless link.exists?
      end

      # does the local directory have a trailing slash?
      if link.unslashed_directory? link.absolute_path
        add_issue("internally linking to a directory #{link.absolute_path} without trailing slash", line)
        next
      end

      # verify the target hash
      handle_hash(link, line) if link.hash
    end

    external_urls
  end

  def check_schemes(link, line)
    case link.scheme
    when 'mailto'
      handle_mailto(link, line)
    when 'tel'
      handle_tel(link, line)
    when 'http'
      add_issue("#{link.href} is not an HTTPS link", line) if @options[:enforce_https]
    end
  end

  def handle_mailto(link, line)
    if link.path.empty?
      add_issue("#{link.href} contains no email address", line)
    elsif !link.path.include?('@')
      add_issue("#{link.href} contains an invalid email address", line)
    end
  end

  def handle_tel(link, line)
    add_issue("#{link.href} contains no phone number", line) if link.path.empty?
  end

  def handle_hash(link, line)
    if link.internal?
      unless hash_check @html, link.hash
        add_issue("linking to internal hash ##{link.hash} that does not exist", line)
      end
    elsif link.external?
      external_link_check(link, line)
    end
  end

  def external_link_check(link, line)
    if !link.exists?
      add_issue("trying to find hash of #{link.href}, but #{link.absolute_path} does not exist", line)
    else
      target_html = create_nokogiri link.absolute_path
      unless hash_check target_html, link.hash
        add_issue("linking to #{link.href}, but #{link.hash} does not exist", line)
      end
    end
  end

  def hash_check(html, href_hash)
    html.xpath("//*[case_insensitive_equals(@id, '#{href_hash}')]", \
               "//*[case_insensitive_equals(@name, '#{href_hash}')]", \
               HTML::Proofer::XpathFunctions.new).length > 0
  end

end
