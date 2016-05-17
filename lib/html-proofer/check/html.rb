class HtmlCheck < ::HTMLProofer::Check
  SCRIPT_EMBEDS_MSG = /Element script embeds close tag/
  INVALID_TAG_MSG = /Tag ([\w\-:]+) invalid/
  INVALID_PREFIX = /Namespace prefix/
  PARSE_ENTITY_REF = /htmlParseEntityRef: no name/

  def run
    @html.errors.each do |error|
      message = error.message
      line    = error.line

      if message =~ INVALID_TAG_MSG || message =~ INVALID_PREFIX
        next unless options[:validation][:report_invalid_tags]
      end

      if message =~ PARSE_ENTITY_REF
        next unless options[:validation][:report_missing_names]
      end

      # tags embedded in scripts are used in templating languages: http://git.io/vOovv
      next if !options[:validation][:report_script_embeds] && message =~ SCRIPT_EMBEDS_MSG

      add_issue(message, line: line)
    end
  end
end
