# encoding: utf-8

class Favicon < ::HTML::Proofer::Checks::Check

  def run
    return unless @options[:favicon]

    @html.css("link").each { |l| return if l["rel"].end_with? "icon" }

    self.add_issue "no favicon included"
  end

end
