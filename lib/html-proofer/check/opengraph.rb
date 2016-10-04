# encoding: utf-8

class OpenGraphElement < ::HTMLProofer::Element
  def src
    @content
  end

  def url
    src
  end
end

class OpenGraphCheck < ::HTMLProofer::Check
  def missing_src?
    !@opengraph.src
  end
  
  def run
    @html.css('meta[property="og:url"], meta[property="og:image"]').each do |m|
      @opengraph = OpenGraphElement.new(m, self)

      next if @opengraph.ignore?

      # does the opengraph exist?
      if missing_src?
        add_issue('open graph is empty and has no content attribute', line: m.line, content: m.content)
      elsif !@opengraph.valid?
        add_issue("#{@opengraph.src} is an invalid URL", line: m.line)
      elsif @opengraph.remote?
        add_to_external_urls(@opengraph.url, m.line)
      else
        add_issue("internal open graph #{@opengraph.url} does not exist", line: m.line, content: m.content) unless @opengraph.exists?
      end
    end

    external_urls
  end
end
