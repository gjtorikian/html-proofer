# frozen_string_literal: true

require "spec_helper"

describe HTMLProofer::Reporter::Terminal do
  describe "report" do
    it "reports all issues accurately" do
      error_file = File.join(FIXTURES_DIR, "sorting", "kitchen_sinkish.html")
      output = make_bin("--checks Links,Images,Scripts,Favicon --no-ignore-missing-alt #{error_file}")

      msg = <<~MSG
        Running 4 checks (Scripts, Links, Images, Favicon) in spec/html-proofer/fixtures/sorting/kitchen_sinkish.html on *.html files ...


        Checking 1 external link
        Checking 1 internal link
        Ran on 1 file!



        For the Favicon check, the following failures were found:

        * At spec/html-proofer/fixtures/sorting/kitchen_sinkish.html:

          no favicon provided

        For the Images check, the following failures were found:

        * At spec/html-proofer/fixtures/sorting/kitchen_sinkish.html:5:

          image ./gpl.png does not have an alt attribute

        * At spec/html-proofer/fixtures/sorting/kitchen_sinkish.html:5:

          internal image ./gpl.png does not exist

        * At spec/html-proofer/fixtures/sorting/kitchen_sinkish.html:6:

          internal image NOT_AN_IMAGE does not exist

        * At spec/html-proofer/fixtures/sorting/kitchen_sinkish.html:10:

          image gpl.png does not have an alt attribute

        * At spec/html-proofer/fixtures/sorting/kitchen_sinkish.html:10:

          internal image gpl.png does not exist

        * At spec/html-proofer/fixtures/sorting/kitchen_sinkish.html:12:

          image has a terrible filename (./Screen Shot 2012-08-09 at 7.51.18 AM.png)

        * At spec/html-proofer/fixtures/sorting/kitchen_sinkish.html:12:

          internal image ./Screen Shot 2012-08-09 at 7.51.18 AM.png does not exist

        * At spec/html-proofer/fixtures/sorting/kitchen_sinkish.html:14:

          image link //upload.wikimedia.org/wikipedia/en/thumb/not_here.png is a protocol-relative URL, use explicit https:// instead

        * At spec/html-proofer/fixtures/sorting/kitchen_sinkish.html:19:

          image link //upload.wikimedia.org/wikipedia/en/thumb/fooooof.png is a protocol-relative URL, use explicit https:// instead

        For the Links check, the following failures were found:

        * At spec/html-proofer/fixtures/sorting/kitchen_sinkish.html:8:

          tel: contains no phone number

        For the Links > External check, the following failures were found:

        * At spec/html-proofer/fixtures/sorting/kitchen_sinkish.html:26:

          External link https://help.github.com/changing-author-info/ failed (status code 403)

        For the Links > Internal check, the following failures were found:

        * At spec/html-proofer/fixtures/sorting/kitchen_sinkish.html:24:

          internally linking to nowhere.fooof, which does not exist


        HTML-Proofer found 13 failures!
      MSG

      expect(output).to(match(msg))
    end

    it "reports as-links accurately" do
      output = make_bin("--as-links www.github.com,http://asdadsadsasdadaf.biz/")

      msg = <<~MSG
        Running 1 check (LinkCheck) on ["www.github.com", "http://asdadsadsasdadaf.biz/"] ...


        Checking 2 external links

        For the Links > External check, the following failures were found:

        * External link http://asdadsadsasdadaf.biz/ failed with something very wrong.
        It's possible libcurl couldn't connect to the server, or perhaps the request timed out.
        Sometimes, making too many requests at once also breaks things. (status code 0)


        HTML-Proofer found 1 failure!
      MSG

      expect(output).to(match(msg))
    end

    it "works with multiple directories" do
      dirs = [File.join(FIXTURES_DIR, "links", "_site"), File.join(FIXTURES_DIR, "images", "webp")].join(" ")
      output = make_bin(dirs)

      expect(output).to(match("spec/html-proofer/fixtures/links/_site"))
      expect(output).to(match("spec/html-proofer/fixtures/images/webp"))
    end
  end
end
