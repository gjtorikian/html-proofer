# encoding: utf-8

class Favicon < ::HTML::Proofer::Checks::Check

  def run
    return unless @options[:favicon]

    found = false
    @html.css('link').each do |l|
      if l['rel'] = 'icon'
        found = true
      end
    end

    self.add_issue "no favicon included" if !found
  end

end
