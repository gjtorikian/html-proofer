# frozen_string_literal: true

require 'spec_helper'

describe HTMLProofer::Reporter::Cli do
  describe 'cli_report' do
    it 'reports all issues accurately' do
      errors = File.join(FIXTURES_DIR, 'sorting', 'kitchen_sinkish.html')
      output = capture_proofer_output(errors, :file, checks: %w[Links Images Scripts Favicon])

      msg = <<~MSG
        For the Favicon check, the following failures were found:

        * In spec/html-proofer/fixtures/sorting/kitchen_sinkish.html:

          no favicon provided

        For the Images check, the following failures were found:

        * In spec/html-proofer/fixtures/sorting/kitchen_sinkish.html (line 5):

          internal image ./gpl.png does not exist

        * In spec/html-proofer/fixtures/sorting/kitchen_sinkish.html (line 5):

          image ./gpl.png does not have an alt attribute

        * In spec/html-proofer/fixtures/sorting/kitchen_sinkish.html (line 6):

          internal image NOT_AN_IMAGE does not exist

        * In spec/html-proofer/fixtures/sorting/kitchen_sinkish.html (line 10):

          internal image gpl.png does not exist

        * In spec/html-proofer/fixtures/sorting/kitchen_sinkish.html (line 10):

          image gpl.png does not have an alt attribute

        * In spec/html-proofer/fixtures/sorting/kitchen_sinkish.html (line 12):

          image has a terrible filename (./Screen Shot 2012-08-09 at 7.51.18 AM.png)

        * In spec/html-proofer/fixtures/sorting/kitchen_sinkish.html (line 12):

          internal image ./Screen Shot 2012-08-09 at 7.51.18 AM.png does not exist

        For the Links check, the following failures were found:

        * In spec/html-proofer/fixtures/sorting/kitchen_sinkish.html (line 8):

          tel: contains no phone number

        For the Links > External check, the following failures were found:

        * In spec/html-proofer/fixtures/sorting/kitchen_sinkish.html (line 14):

          External link https://upload.wikimedia.org/wikipedia/en/thumb/not_here.png failed (status code 404)

        * In spec/html-proofer/fixtures/sorting/kitchen_sinkish.html (line 19):

          External link https://upload.wikimedia.org/wikipedia/en/thumb/fooooof.png failed (status code 404)

        * In spec/html-proofer/fixtures/sorting/kitchen_sinkish.html (line 26):

          External link https://help.github.com/changing-author-info/ failed (status code 404)

        For the Links > Internal check, the following failures were found:

        * In spec/html-proofer/fixtures/sorting/kitchen_sinkish.html (line 24):

          internally linking to nowhere.fooof, which does not exist


        HTML-Proofer found 13 failures!
      MSG

      expect(output).to match(msg)
    end

    it 'reports as-links accurately' do
      output = capture_proofer_output(['www.github.com', 'http://asdadsadsasdadaf.biz/'], :links)

      msg = <<~MSG
        For the Links > External check, the following failures were found:

        * External link http://asdadsadsasdadaf.biz/ failed with something very wrong.
        It's possible libcurl couldn't connect to the server, or perhaps the request timed out.
        Sometimes, making too many requests at once also breaks things.

        Either way, the return message from the server is: OK (status code 0)


        HTML-Proofer found 1 failure!
      MSG

      expect(output).to match(msg)
    end
  end
end
