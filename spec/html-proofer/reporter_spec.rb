# frozen_string_literal: true

require 'spec_helper'

class CustomReporter < ::HTMLProofer::Reporter
  def report
    @logger.log(:error, "Womp womp, found #{failures.size} issues")
  end
end

describe HTMLProofer::Reporter do
  it 'supports a custom reporter' do
    file = File.join(FIXTURES_DIR, 'sorting', 'kitchen_sinkish.html')
    cassette_name = make_cassette_name(file, {})

    VCR.use_cassette(cassette_name, record: :new_episodes) do
      proofer = make_proofer(file, :file, {})
      proofer.reporter = CustomReporter.new(logger: proofer.logger)
      output = capture_stderr { proofer.run }
      expect(output).to include('Womp womp, found')
    end
  end
end
