# encoding: utf-8

class ImageCheckable < ::HTML::Proofer::Checkable

  SCREEN_SHOT_REGEX = /Screen(?: |%20)Shot(?: |%20)\d+-\d+-\d+(?: |%20)at(?: |%20)\d+.\d+.\d+/

  def valid_alt_tag?
    @alt && !empty_alt_tag?
  end

  def empty_alt_tag?
    @alt.strip.empty?
  end

  def terrible_filename?
    src =~ SCREEN_SHOT_REGEX
  end

  def src
    real_attr(@src) || real_attr(@srcset)
  end

  def missing_src?
    !src
  end

end

class ImageCheck < ::HTML::Proofer::CheckRunner
  def run
    @html.css('img').each do |i|
      img = ImageCheckable.new i, self

      next if img.ignore?

      # screenshot filenames should return because of terrible names
      next add_issue("image has a terrible filename (#{img.src})", i.line) if img.terrible_filename?

      # does the image exist?
      if img.missing_src?
        add_issue('image has no src or srcset attribute', i.line)
      else
        if img.remote?
          add_to_external_urls img.src
        else
          add_issue("internal image #{img.src} does not exist", i.line) unless img.exists?
        end
      end

      # check alt tag
      add_issue("image #{img.src} does not have an alt attribute", i.line) unless img.valid_alt_tag?
    end

    external_urls
  end
end
