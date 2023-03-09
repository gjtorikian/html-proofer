# frozen_string_literal: true

module HTMLProofer
  class Check
    class OpenGraph < HTMLProofer::Check
      def run
        @html.css('meta[property="og:url"], meta[property="og:image"]').each do |node|
          @open_graph = create_element(node)

          next if @open_graph.ignore?

          # does the open_graph exist?
          if missing_content?
            add_failure("open graph has no content attribute", element: @open_graph)
          elsif empty_content?
            add_failure("open graph content attribute is empty", element: @open_graph)
          elsif !@open_graph.url.valid?
            add_failure("#{@open_graph.src} is an invalid URL", element: @open_graph)
          elsif @open_graph.url.protocol_relative?
            add_failure(
              "open graph link #{@open_graph.url} is a protocol-relative URL, use explicit https:// instead",
              element: @open_graph,
            )
          elsif @open_graph.url.remote?
            add_to_external_urls(@open_graph.url, @open_graph.line)
          else
            add_failure(
              "internal open graph #{@open_graph.url.raw_attribute} does not exist",
              element: @open_graph,
            ) unless @open_graph.url.exists?
          end
        end

        external_urls
      end

      private def missing_content?
        @open_graph.node["content"].nil?
      end

      private def empty_content?
        @open_graph.node["content"].empty?
      end
    end
  end
end
