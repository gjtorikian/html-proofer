# frozen_string_literal: true

require 'spec_helper'

class MailToOctocat < ::HTMLProofer::Check
  def mailto_octocat?
    @link.url.raw_attribute == 'mailto:octocat@github.com'
  end

  def run
    @html.css('a').each do |node|
      @link = create_element(node)

      next if @link.ignore?

      return add_failure("Don't email the Octocat directly!", line: @link.line) if mailto_octocat?
    end
  end
end

describe HTMLProofer::Reporter do
  it 'supports a custom reporter' do
    file = File.join(FIXTURES_DIR, 'links', 'mailto_octocat.html')
    cassette_name = make_cassette_name(file, {})

    VCR.use_cassette(cassette_name, record: :new_episodes) do
      proofer = make_proofer(file, :file, { checks: ['MailToOctocat'] })
      output = capture_stderr { proofer.run }
      expect(output).to include("In #{file} (line 1)")
    end
  end
end
