# encoding: utf-8

class Image < ::HTML::Proofer::Checkable

  SCREEN_SHOT_REGEX = /Screen(?: |%20)Shot(?: |%20)\d+-\d+-\d+(?: |%20)at(?: |%20)\d+.\d+.\d+/

  def valid_alt_tag?
    @alt and !@alt.empty?
  end

  def terrible_filename?
    @src =~ SCREEN_SHOT_REGEX
  end

  def src
    @src unless @src.nil? || @src.empty?
  end

  def missing_src?
    !src
  end

end

class Images < ::HTML::Proofer::Checks::Check

  def run
    @html.css('img').each do |img|

      img = Image.new img, self

      # screenshot filenames, return because invalid URL
      return self.add_issue "image has a terrible filename (#{img.src})" if img.terrible_filename?

      # does the image exist?
      if img.missing_src?
        self.add_issue "image has no src attribute"
      elsif img.remote?
        validate_url img.src, "external image #{img.src} does not exist"
      else
        self.add_issue("internal image #{img.src} does not exist") unless img.exists?
      end

      # check alt tag
      self.add_issue "image #{img.src} does not have an alt attribute" unless img.valid_alt_tag?


    end
  end
end
