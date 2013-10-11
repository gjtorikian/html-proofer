# encoding: utf-8

class Image

  SCREEN_SHOT_REGEX = /Screen(?: |%20)Shot(?: |%20)\d+-\d+-\d+(?: |%20)at(?: |%20)\d+.\d+.\d+/

  def initialize(img)
    @img = img
  end

  def valid_alt_tag?
    @img['alt'] and !@img['alt'].empty?
  end

  def terrible_filename?
    src =~ SCREEN_SHOT_REGEX
  end

  def src
    @img['src'] if @img['src'] && @img['src'].length > 0
  end

  def missing_src?
    !src
  end

end

class Images < ::HTML::Proofer::Checks::Check

  def run
    @html.css('img').each do |img|

      img = Image.new img

      # does the image exist?
      if img.missing_src?
        self.add_issue "image has no src attribute"
      elsif external_href? img.src
        validate_url img.src, "external image #{img.src} does not exist"
      else
        self.add_issue("internal image #{img.src} does not exist") unless file? img.src
      end

      # check alt tag
      self.add_issue "image #{img.src} does not have an alt attribute" unless img.valid_alt_tag?

      # screenshot filenames
      self.add_issue "image has a terrible filename (#{img.src})" if img.terrible_filename?

    end
  end
end
