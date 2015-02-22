# encoding: utf-8

class OpengraphCheckable < ::HTML::Proofer::Checkable

  def src
    @content
  end

  def missing_src?
    !src
  end

  def url
    src
  end
end

class OpengraphCheck < ::HTML::Proofer::CheckRunner
  def run
    @html.css('meta[property="og:url"], meta[property="og:image"]').each do |m|
      opengraph = OpengraphCheckable.new m, self

      next if opengraph.ignore?

      # does the opengraph exist?
      if opengraph.missing_src?
        add_issue('open graph is empty and has no content attribute', m.line)
      elsif opengraph.remote?
        add_to_external_urls opengraph.src
      else
        add_issue("internal open graph #{opengraph.src} does not exist", m.line) unless opengraph.exists?
      end
    end

    external_urls
  end
end
