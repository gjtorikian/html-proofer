# frozen_string_literal: true

class HTMLProofer::Check::Images < HTMLProofer::Check
  include HTMLProofer::Utils

  SCREEN_SHOT_REGEX = /Screen(?: |%20)Shot(?: |%20)\d+-\d+-\d+(?: |%20)at(?: |%20)\d+.\d+.\d+/.freeze

  def run
    @html.css('img').each do |node|
      @img = create_element(node)
      line = node.line
      content = node.content

      next if @img.ignore?

      # screenshot filenames should return because of terrible names
      add_issue("image has a terrible filename (#{@img.url.raw_attribute})", line: line, content: content) if terrible_filename?

      # does the image exist?
      if missing_src?
        add_issue('image has no src or srcset attribute', line: line, content: content)
      elsif @img.url.remote?
        add_to_external_urls(@img.url, line)
      elsif !@img.url.exists?
        add_issue("internal image #{@img.url.raw_attribute} does not exist", line: line, content: content)
      end

      add_issue("image #{@img.url.raw_attribute} does not have an alt attribute", line: line, content: content) if empty_alt_tag? && !ignore_missing_alt? && !ignore_alt?

      add_issue("image #{@img.url.raw_attribute} uses the http scheme", line: line, content: content) if @runner.enforce_https? && @img.url.http?
    end

    external_urls
  end

  def ignore_missing_alt?
    @runner.options[:ignore_missing_alt]
  end

  def ignore_alt?
    @img.matches_ignore_pattern?(@runner.options[:alt_ignore]) || @img.aria_hidden?
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
