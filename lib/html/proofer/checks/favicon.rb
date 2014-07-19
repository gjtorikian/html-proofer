# encoding: utf-8

class Favicon < ::HTML::Proofer::Checks::Check

  def run
    return unless @options[:favicon]

    @html.css("link").each do |l|
      return if l["rel"] = "icon"
    end

    self.add_issue "no favicon included"
  end

end
