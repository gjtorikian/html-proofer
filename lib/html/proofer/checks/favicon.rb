# encoding: utf-8

class FaviconCheckable < ::HTML::Proofer::Checkable
  def rel
    @rel
  end
end

class FaviconCheck < ::HTML::Proofer::CheckRunner

  def run
    @html.xpath('//link[not(ancestor::pre or ancestor::code)]').each do |f|
      begin
        favicon = FaviconCheckable.new f, self
      rescue NameError => e
        next add_issue(e, f.line)
      end

      next if favicon.ignore?
      return if favicon.rel.split(' ').last.eql? 'icon'
    end

    add_issue 'no favicon specified'
  end

end
