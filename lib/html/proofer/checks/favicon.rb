# encoding: utf-8

class Favicon < ::HTML::Proofer::Checks::Check

  def run
    return unless @options[:favicon]

    @html.css("link").each { |link|
      return if link["rel"].split(" ").last.eql? "icon"
    }

    self.add_issue "no favicon specified"
  end

end
