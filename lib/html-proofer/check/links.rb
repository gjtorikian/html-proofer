class LinkCheck < ::HTMLProofer::Check
  include HTMLProofer::Utils

  def missing_href?
    blank?(@link.href) && blank?(@link.name) && blank?(@link.id)
  end

  def placeholder?
    (!blank?(@link.id) || !blank?(@link.name)) && @link.href.nil?
  end

  def run
    @html.css('a, link').each do |node|
      @link = create_element(node)
      line = @node.line

      next if @link.ignore?

      next if placeholder?
      next if @link.allow_hash_href? && @link.href == '#'

      # is it even a valid URL?
      unless @link.valid?
        add_issue("#{@link.href} is an invalid URL", line: line)
        next
      end

      check_schemes(@link, line)

      # is there even an href?
      if missing_href?
        # HTML5 allows dropping the href: http://git.io/vBX0z
        next if @html.internal_subset.name == 'html' && @html.internal_subset.external_id.nil?
        add_issue('anchor has no href attribute', line: line)
        next
      end

      # intentionally here because we still want valid? & missing_href? to execute
      next if @link.non_http_remote?
      # does the file even exist?
      if @link.remote?
        add_to_external_urls(@link.href, line)
        next
      elsif !@link.internal? && !@link.exists?
        add_issue("internally linking to #{@link.href}, which does not exist", line: line)
      end

      # does the local directory have a trailing slash?
      if @link.unslashed_directory? @link.absolute_path
        add_issue("internally linking to a directory #{@link.absolute_path} without trailing slash", line: line)
        next
      end

      # verify the target hash
      handle_hash(@link, line) if @link.hash
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
      return unless @options[:enforce_https]
      add_issue("#{link.href} is not an HTTPS link", line: line)
    end
  end

  def handle_mailto(link, line)
    if link.path.empty?
      add_issue("#{link.href} contains no email address", line: line)
    elsif !link.path.include?('@')
      add_issue("#{link.href} contains an invalid email address", line: line)
    end
  end

  def handle_tel(link, line)
    add_issue("#{link.href} contains no phone number", line: line) if link.path.empty?
  end

  def handle_hash(link, line)
    if link.internal?
      unless hash_check @html, link.hash
        add_issue("linking to internal hash ##{link.hash} that does not exist", line: line)
      end
    elsif link.external?
      external_link_check(link, line)
    end
  end

  def external_link_check(link, line)
    if !link.exists?
      add_issue("trying to find hash of #{link.href}, but #{link.absolute_path} does not exist", line: line)
    else
      target_html = create_nokogiri link.absolute_path
      unless hash_check target_html, link.hash
        add_issue("linking to #{link.href}, but #{link.hash} does not exist", line: line)
      end
    end
  end

  def hash_check(html, href_hash)
    decoded_href_hash = URI.decode(href_hash)
    html.xpath("//*[case_insensitive_equals(@id, '#{href_hash}')]", \
               "//*[case_insensitive_equals(@name, '#{href_hash}')]", \
               "//*[case_insensitive_equals(@id, '#{decoded_href_hash}')]", \
               "//*[case_insensitive_equals(@name, '#{decoded_href_hash}')]", \
               XpathFunctions.new).length > 0
  end

  class XpathFunctions
    def case_insensitive_equals(node_set, str_to_match)
      node_set.find_all {|node| node.to_s.downcase == str_to_match.to_s.downcase }
    end
  end
end
