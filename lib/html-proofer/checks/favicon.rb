class FaviconCheckable < ::HTMLProofer::Checkable
  attr_reader :rel
end

class FaviconCheck < ::HTMLProofer::CheckRunner
  def run
    found = false
    @html.xpath('//link[not(ancestor::pre or ancestor::code)]').each do |node|
      favicon = FaviconCheckable.new(node, self)
      next if favicon.ignore?
      found = true if favicon.rel.split(' ').last.eql? 'icon'
      break if found
    end

    return if found

    add_issue 'no favicon specified'
  end
end
