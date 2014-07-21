# encoding: utf-8

class Script < ::HTML::Proofer::Checkable

  def src
    @src unless @src.nil? || @src.empty?
  end

  def missing_src?
    !src
  end

  def blank?
    @content.strip.empty?
  end

end

class Scripts < ::HTML::Proofer::Checks::Check
  def run
    @html.xpath('//script[not(ancestor::pre or ancestor::code)]').each do |s|
      script = Script.new s, "script", self

      next if script.ignore?
      next unless script.blank?

      # does the script exist?
      if script.missing_src?
        self.add_issue "script is empty and has no src attribute"
      elsif script.remote?
        add_to_external_urls script.src
      else
        self.add_issue("internal script #{script.src} does not exist") unless script.exists?
      end

    end

    external_urls
  end
end
