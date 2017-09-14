class FaviconCheck < ::HTMLProofer::Check
  def run
    found = false
    @html.xpath('//link[not(ancestor::pre or ancestor::code)]').each do |node|
      favicon = create_element(node)
      next if favicon.ignore?
      found = true if favicon.rel.split(' ').last.eql? 'icon'
      break if found
    end

    return if found

    return if is_redirect_only?

    add_issue('no favicon specified')
  end
  
  def is_redirect_only?
    # specific match for Jekyll's redirect_from template:
    # https://git.io/v5stq
    @html.xpath('//title').text == 'Redirecting…'
  end
  
end
