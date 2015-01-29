# encoding: utf-8

class HtmlCheck < ::HTML::Proofer::CheckRunner

  # new html5 tags (source: http://www.w3schools.com/html/html5_new_elements.asp)
  HTML5_TAGS = %w(article aside bdi details dialog figcaption
                  figure footer header main mark menuitem meter
                  nav progress rp rt ruby section summary
                  time wbr datalist keygen output color date
                  datetime datetime-local email month number
                  range search tel time url week canvas
                  svg audio embed source track video)

  def run
    @html.errors.each do |e|
      # Nokogiri (or rather libxml2 underhood) only recognizes html4 tags,
      # so we need to skip errors caused by the new tags in html5
      next if HTML5_TAGS.include? e.to_s[/Tag ([\w-]+) invalid/o, 1]

      add_issue(e.to_s)
    end
  end
end
