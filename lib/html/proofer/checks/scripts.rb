# encoding: utf-8

class ScriptCheckable < ::HTML::Proofer::Checkable

  def src
    real_attr @src
  end

  def missing_src?
    !src
  end

  def blank?
    @text.strip.empty?
  end

end

class ScriptCheck < ::HTML::Proofer::CheckRunner
  def run
    @html.css('script').each do |node|
      script = ScriptCheckable.new(node, self)
      line = node.line

      next if script.ignore?
      next unless script.blank?

      # does the script exist?
      if script.missing_src?
        add_issue('script is empty and has no src attribute', line)
      elsif script.remote?
        add_to_external_urls(script.src, line)
      else
        add_issue("internal script #{script.src} does not exist", line) unless script.exists?
      end
    end

    external_urls
  end
end
