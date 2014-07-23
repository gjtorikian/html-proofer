# encoding: utf-8

class Favicon < ::HTML::Proofer::Checkable
  def rel
    @rel
  end
end

class Favicons < ::HTML::Proofer::Checks::Check

  def run
    return unless @options[:favicon]

    @html.xpath("//link[not(ancestor::pre or ancestor::code)]").each do |f|
      favicon = Favicon.new f, "favicon", self
      next if favicon.ignore?
      return if favicon.rel.split(" ").last.eql? "icon"
    end

    self.add_issue "no favicon specified"
  end

end
