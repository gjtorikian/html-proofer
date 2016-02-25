class ScriptCheck < ::HTMLProofer::Check
  attr_reader :src

  def missing_src?
    !@script.src
  end

  def run
    @html.css('script').each do |node|
      @script = create_element(node)
      line = node.line

      next if @script.ignore?
      next unless node.text.strip.empty?

      # does the script exist?
      if missing_src?
        add_issue('script is empty and has no src attribute', line: line)
      elsif @script.remote?
        add_to_external_urls(@script.src, line)
      elsif !@script.exists?
        add_issue("internal script #{@script.src} does not exist", line: line)
      end
    end

    external_urls
  end
end
