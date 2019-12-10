# frozen_string_literal: true

class HtmlCheck < ::HTMLProofer::Check
  # tags embedded in scripts are used in templating languages: http://git.io/vOovv
  SCRIPT_EMBEDS_MSG = /Element script embeds close tag/.freeze
  INVALID_TAG_MSG = /Tag ([\w\-:]+) invalid/.freeze
  INVALID_PREFIX = /Namespace prefix/.freeze
  PARSE_ENTITY_REF = /htmlParseEntityRef: no name/.freeze
  DOCTYPE_MSG = /The doctype must be the first token in the document/.freeze

  def run
    @html.errors.each do |error|
      add_issue(error.message, line: error.line) if report?(error.message)
    end
  end

  def report?(message)
    case message
    when SCRIPT_EMBEDS_MSG
      options[:validation][:report_script_embeds]
    when INVALID_TAG_MSG, INVALID_PREFIX
      options[:validation][:report_invalid_tags]
    when PARSE_ENTITY_REF
      options[:validation][:report_missing_names]
    when DOCTYPE_MSG
      options[:validation][:report_missing_doctype]
    else
      true
    end
  end
end
