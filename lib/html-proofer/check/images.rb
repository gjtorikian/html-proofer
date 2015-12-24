class ImageCheck < ::HTMLProofer::Check
  SCREEN_SHOT_REGEX = /Screen(?: |%20)Shot(?: |%20)\d+-\d+-\d+(?: |%20)at(?: |%20)\d+.\d+.\d+/

  attr_reader :alt

  def empty_alt_tag?
    @img.alt.strip.empty?
  end

  def terrible_filename?
    @img.url =~ SCREEN_SHOT_REGEX
  end

  def missing_src?
    blank?(@img.url)
  end

  def run
    @html.css('img').each do |node|
      @img = create_element(node)
      line = node.line

      next if @img.ignore?

      # screenshot filenames should return because of terrible names
      next add_issue("image has a terrible filename (#{@img.url})", line) if terrible_filename?

      # does the image exist?
      if missing_src?
        add_issue('image has no src or srcset attribute', line)
      else
        if @img.remote?
          add_to_external_urls(@img.url, line)
        else
          add_issue("internal image #{@img.url} does not exist", line) unless @img.exists?
        end
      end

      if @img.alt.nil? || (empty_alt_tag? && !@img.ignore_empty_alt?)
        add_issue("image #{@img.url} does not have an alt attribute", line)
      end
    end

    external_urls
  end
end
