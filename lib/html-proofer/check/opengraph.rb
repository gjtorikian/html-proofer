# encoding: utf-8

class OpenGraphCheck < ::HTMLProofer::Check
  def src
    @content
  end


  def missing_src?
    !src
  end


  def url
    src
  end


  def run
    @html.css('meta[property="og:url"], meta[property="og:image"]').each do |m|
      @opengraph = create_element(m)

      next if @opengraph.ignore?

      # does the opengraph exist?
      if missing_src?
        add_issue('open graph is empty and has no content attribute', line: m.line, content: m.content)
      elsif @opengraph.remote?
        add_to_external_urls opengraph.src, m.line
      else
        add_issue("internal open graph #{@opengraph.src} does not exist", line: m.line, content: m.content) unless @opengraph.exists?
      end
    end

    external_urls
  end
end
