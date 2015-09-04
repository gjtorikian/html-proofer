# encoding: utf-8

class HtmlCheck < ::HTML::Proofer::CheckRunner
  # new html5 tags (source: http://www.w3schools.com/html/html5_new_elements.asp)
  # and svg child tags (source: https://developer.mozilla.org/en-US/docs/Web/SVG/Element)
  HTML5_TAGS = %w(article aside bdi details dialog figcaption
                  figure footer header main mark menuitem meter
                  nav progress rp rt ruby section summary
                  time wbr datalist keygen output color date
                  datetime datetime-local email month number
                  range search tel time url week canvas
                  svg audio embed source track video
                  altGlyph altGlyphDef altGlyphItem animate
                  animateColor animateMotion animateTransform
                  circle clipPath color-profile cursor defs
                  desc ellipse feBlend feColorMatrix
                  feComponentTransfer feComposite feConvolveMatrix
                  feDiffuseLighting feDisplacementMap feDistantLight
                  feFlood feFuncA feFuncB feFuncG feFuncR feGaussianBlur
                  feImage feMerge feMergeNode feMorphology feOffset
                  fePointLight feSpecularLighting feSpotLight feTile
                  feTurbulence filter font font-face font-face-format
                  font-face-name font-face-src font-face-uri
                  foreignObject g glyph glyphRef hkern image line
                  linearGradient marker mask metadata missing-glyph
                  mpath path pattern polygon polyline radialGradient
                  rect set stop switch symbol text textPath tref tspan use
                  view vkern)

  SCRIPT_EMBEDS_MSG = /Element script embeds close tag/

  def run
    @html.errors.each do |error|
      message = error.message
      line    = error.line
      # Nokogiri (or rather libxml2 underhood) only recognizes html4 tags,
      # so we need to skip errors caused by the new tags in html5
      next if HTML5_TAGS.include? message[/Tag ([\w-]+) invalid/o, 1]

      # tags embedded in scripts are used in templating languages: http://git.io/vOovv
      next if @validation_opts[:ignore_script_embeds] && message =~ SCRIPT_EMBEDS_MSG

      add_issue(message, line)
    end
  end
end
