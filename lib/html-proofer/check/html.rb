class HtmlCheck < ::HTMLProofer::Check
  SCRIPT_EMBEDS_MSG = /Element script embeds close tag/
  INVALID_TAG_MSG = /Tag ([\w-]+) invalid/

  def run
    @html.errors.each do |error|
      message = error.message
      line    = error.line

      next if !options[:validation][:report_invalid_tags] && message =~ INVALID_TAG_MSG

      # tags embedded in scripts are used in templating languages: http://git.io/vOovv
      next if options[:validation][:ignore_script_embeds] && message =~ SCRIPT_EMBEDS_MSG

      add_issue(message, line_number: line)
    end
  end
end
