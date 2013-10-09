# encoding: utf-8

class Images < ::HTML::Proofer::Checks::Check

  def run
    @html.css('img').each do |img|
      src = img['src']

      # check image sources
      if src && src.length > 0
        if !external_href?(src)
          self.add_issue("#{@path}".blue + ": internal image #{src} does not exist") unless File.exist?( resolve_path(src))
        else
          validate_url(src, "#{@path}".blue + ": external image #{src} does not exist")
        end
      else
        self.add_issue("#{@path}".blue + ": image has no src attribute")
      end

      # check alt tag
      self.add_issue("#{@path}".blue + ": image #{src} does not have an alt attribute") unless img['alt'] and !img['alt'].empty?

      screenShotRegExp = /Screen(?: |%20)Shot(?: |%20)\d+-\d+-\d+(?: |%20)at(?: |%20)\d+.\d+.\d+/

      if src =~ screenShotRegExp
        self.add_issue("#{@path}".blue + ": image has a terrible filename (#{src})")
      end
    end
  end
end
