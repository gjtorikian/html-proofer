# encoding: utf-8

class ImageCheckable < ::HTML::Proofer::Checkable
  SCREEN_SHOT_REGEX = /Screen(?: |%20)Shot(?: |%20)\d+-\d+-\d+(?: |%20)at(?: |%20)\d+.\d+.\d+/

  attr_reader :alt

  def empty_alt_tag?
    alt.strip.empty?
  end

  def terrible_filename?
    url =~ SCREEN_SHOT_REGEX
  end

  def missing_src?
    url.nil? || url.empty?
  end
end

class ImageCheck < ::HTML::Proofer::CheckRunner
  def run
    @html.css('img').each do |node|
      img = ImageCheckable.new(node, self)
      line = node.line

      next if img.ignore?

      # screenshot filenames should return because of terrible names
      next add_issue("image has a terrible filename (#{img.url})", line) if img.terrible_filename?

      # does the image exist?
      if img.missing_src?
        add_issue('image has no src or srcset attribute', line)
      else
        if img.remote?
          add_to_external_urls(img.url, line)
        else
          add_issue("internal image #{img.url} does not exist", line) unless img.exists?
        end
      end

      if img.alt.nil? || (img.empty_alt_tag? && !img.ignore_empty_alt?)
        add_issue("image #{img.url} does not have an alt attribute", line)
      end
    end

    external_urls
  end
end
