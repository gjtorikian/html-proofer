# frozen_string_literal: true

class HTMLProofer::Check::Images < HTMLProofer::Check
  SCREEN_SHOT_REGEX = /Screen(?: |%20)Shot(?: |%20)\d+-\d+-\d+(?: |%20)at(?: |%20)\d+.\d+.\d+/.freeze

  def run
    @html.css('img').each do |node|
      @img = create_element(node)

      next if @img.ignore?

      # screenshot filenames should return because of terrible names
      add_failure("image has a terrible filename (#{@img.url.raw_attribute})", line: @img.line, content: @img.content) if terrible_filename?

      # does the image exist?
      if missing_src?
        add_failure('image has no src or srcset attribute', line: @img.line, content: @img.content)
      elsif @img.url.remote?
        add_to_external_urls(@img.url, @img.line)
      elsif !@img.url.exists? && !@img.multiple_srcsets?
        add_failure("internal image #{@img.url.raw_attribute} does not exist", line: @img.line, content: @img.content)
      elsif @img.multiple_srcsets?
        srcsets = @img.srcset.split(',').map(&:strip)
        srcsets.each do |srcset|
          srcset_url = HTMLProofer::Attribute::Url.new(@runner, srcset, base_url: @img.base_url)

          if srcset_url.remote?
            add_to_external_urls(srcset_url.url, @img.line)
          elsif !srcset_url.exists?
            add_failure("internal image #{srcset} does not exist", line: @img.line, content: @img.content)
          end
        end
      end

      add_failure("image #{@img.url.raw_attribute} does not have an alt attribute", line: @img.line, content: @img.content) if empty_alt_tag? && !ignore_missing_alt? && !ignore_alt?

      add_failure("image #{@img.url.raw_attribute} uses the http scheme", line: @img.line, content: @img.content) if @runner.enforce_https? && @img.url.http?
    end

    external_urls
  end

  def ignore_missing_alt?
    @runner.options[:ignore_missing_alt]
  end

  def ignore_alt?
    @img.url.ignore? || @img.aria_hidden?
  end

  def empty_alt_tag?
    @img.node['alt'].nil? || @img.node['alt'].strip.empty?
  end

  def terrible_filename?
    @img.url.to_s =~ SCREEN_SHOT_REGEX
  end

  def missing_src?
    blank?(@img.url.to_s)
  end
end
