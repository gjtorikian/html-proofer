class ImageCheck < ::HTMLProofer::Check
  SCREEN_SHOT_REGEX = /Screen(?: |%20)Shot(?: |%20)\d+-\d+-\d+(?: |%20)at(?: |%20)\d+.\d+.\d+/

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
      if terrible_filename?
        add_issue("image has a terrible filename (#{@img.url})", line: line)
        next
      end

      # does the image exist?
      if missing_src?
        add_issue('image has no src or srcset attribute', line: line)
      else
        if @img.remote?
          add_to_external_urls(@img.url, line)
        elsif !@img.exists?
          add_issue("internal image #{@img.url} does not exist", line: line)
        end
      end

      if !@img.ignore_alt? && (@img.alt.nil? || (empty_alt_tag? && !@img.ignore_empty_alt?))
        add_issue("image #{@img.url} does not have an alt attribute", line: line)
      end
    end

    external_urls
  end
end
