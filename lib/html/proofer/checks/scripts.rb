# encoding: utf-8

class ScriptCheck < ::HTML::Proofer::Checkable

  def src
    real_attr @src
  end

  def missing_src?
    !src
  end

  def blank?
    @content.strip.empty?
  end

end

class ScriptRunner < ::HTML::Proofer::Runner
  def run
    @html.css('script').each do |s|
      script = ScriptCheck.new s, self

      next if script.ignore?
      next unless script.blank?

      # does the script exist?
      if script.missing_src?
        add_issue 'script is empty and has no src attribute'
      elsif script.remote?
        add_to_external_urls script.src
      else
        add_issue("internal script #{script.src} does not exist") unless script.exists?
      end
    end

    external_urls
  end
end
