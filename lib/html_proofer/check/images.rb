# frozen_string_literal: true

module HTMLProofer
  class Check
    class Images < HTMLProofer::Check
      SCREEN_SHOT_REGEX = /Screen(?: |%20)Shot(?: |%20)\d+-\d+-\d+(?: |%20)at(?: |%20)\d+.\d+.\d+/

      def run
        @html.css("img, source").each do |node|
          @img = create_element(node)

          next if @img.ignore?

          # screenshot filenames should return because of terrible names
          add_failure(
            "image has a terrible filename (#{@img.url.raw_attribute})",
            element: @img,
          ) if terrible_filename?

          # does the image exist?
          if missing_src?
            add_failure("image has no src or srcset attribute", element: @img)
          elsif @img.url.protocol_relative?
            add_failure(
              "image link #{@img.url} is a protocol-relative URL, use explicit https:// instead",
              element: @img,
            )
          elsif @img.url.remote?
            add_to_external_urls(@img.url, @img.line)
          elsif !@img.url.exists? && !@img.multiple_srcsets? && !@img.multiple_sizes?
            add_failure(
              "internal image #{@img.url.raw_attribute} does not exist",
              element: @img,
            )
          elsif @img.multiple_srcsets? || @img.multiple_sizes?
            @img.srcsets_wo_sizes.each do |srcset|
              srcset_url = HTMLProofer::Attribute::Url.new(@runner, srcset, base_url: @img.base_url, source: @img.url.source, filename: @img.url.filename, extract_size: true)

              if srcset_url.protocol_relative?
                add_failure(
                  "image link #{srcset_url.url} is a protocol-relative URL, use explicit https:// instead",
                  element: @img,
                )
              elsif srcset_url.remote?
                add_to_external_urls(srcset_url.url, @img.line)
              elsif !srcset_url.exists?
                add_failure("internal image #{srcset} does not exist", element: @img)
              end
            end
          end

          # if this is an img element, check that the alt attribute is present
          if @img.img_tag? && !ignore_element?
            if missing_alt_tag? && !ignore_missing_alt?
              add_failure(
                "image #{@img.url.raw_attribute} does not have an alt attribute",
                element: @img,
              )
            elsif (empty_alt_tag? || alt_all_spaces?) && !ignore_empty_alt?
              add_failure(
                "image #{@img.url.raw_attribute} has an alt attribute, but no content",
                element: @img,
              )
            end
          end

          add_failure(
            "image #{@img.url.raw_attribute} uses the http scheme",
            element: @img,
          ) if @runner.enforce_https? && @img.url.http?
        end

        external_urls
      end

      def ignore_missing_alt?
        @runner.options[:ignore_missing_alt]
      end

      def ignore_empty_alt?
        @runner.options[:ignore_empty_alt]
      end

      def ignore_element?
        @img.url.ignore? || @img.aria_hidden?
      end

      def missing_alt_tag?
        @img.node["alt"].nil?
      end

      def empty_alt_tag?
        !missing_alt_tag? && @img.node["alt"].empty?
      end

      def empty_whitespace_alt_tag?
        !missing_alt_tag? && @img.node["alt"].strip.empty?
      end

      def alt_all_spaces?
        !missing_alt_tag? && @img.node["alt"].split.all?(" ")
      end

      def terrible_filename?
        @img.url.to_s =~ SCREEN_SHOT_REGEX
      end

      def missing_src?
        blank?(@img.url.to_s)
      end
    end
  end
end
