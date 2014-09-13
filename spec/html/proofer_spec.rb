require "spec_helper"

describe HTML::Proofer do

  describe "#failed_tests" do
    it "is a list of the formatted errors" do
      brokenLinkInternalFilepath = "#{FIXTURES_DIR}/links/brokenLinkInternal.html"
      proofer = make_proofer(brokenLinkInternalFilepath)
      proofer.failed_tests.should eq(["\e[34mspec/html/proofer/fixtures/links/brokenLinkInternal.html\e[0m: internally linking to ./notreal.html, which does not exist", "\e[34mspec/html/proofer/fixtures/links/brokenLinkInternal.html\e[0m: internally linking to ./missingImageAlt.html, which does not exist"])
    end
  end

  describe "#files" do
    it "works for directory that ends with .html" do
      folder = "#{FIXTURES_DIR}/links/_site/folder.html"
      proofer = HTML::Proofer.new folder
      proofer.files.should == ["#{folder}/index.html"]
    end
  end

  describe "#options" do
    it "strips out undesired Typhoeus options" do
      folder = "#{FIXTURES_DIR}/links/_site/folder.html"
      proofer = HTML::Proofer.new folder, :verbose => true
      proofer.options[:verbose].should == true
      proofer.typhoeus_opts[:verbose].should == nil
    end

    it "takes options for Parallel" do
      folder = "#{FIXTURES_DIR}/links/_site/folder.html"
      proofer = HTML::Proofer.new folder, :parallel => { :in_processes => 3 }
      proofer.parallel_opts[:in_processes].should == 3
      proofer.typhoeus_opts[:in_processes].should == nil
      proofer.options[:parallel].should == nil
    end

    describe "sorting" do
      it "understands sorting by path" do
        output = send_proofer_output("#{FIXTURES_DIR}/sorting/path")
        output.strip.should == """
spec/html/proofer/fixtures/sorting/path/multiple_issues.html
  *  internal image gpl.png does not exist
  *  image gpl.png does not have an alt attribute
  *  tel: is an invalid URL
spec/html/proofer/fixtures/sorting/path/single_issue.html
  *  image has a terrible filename (./Screen Shot 2012-08-09 at 7.51.18 AM.png)
""".strip
      end

      it "understands sorting by issue" do
        output = send_proofer_output("#{FIXTURES_DIR}/sorting/issue", :error_sort => :desc)
        output.strip.should == """
image ./gpl.png does not have an alt attribute
  *  spec/html/proofer/fixtures/sorting/issue/broken_image_two.html
  *  spec/html/proofer/fixtures/sorting/issue/broken_image_one.html
internal image ./gpl.png does not exist
  *  spec/html/proofer/fixtures/sorting/issue/broken_image_one.html
  *  spec/html/proofer/fixtures/sorting/issue/broken_image_two.html
internal image NOT_AN_IMAGE does not exist
  *  spec/html/proofer/fixtures/sorting/issue/broken_image_two.html
      """.strip
      end


      it "understands sorting by status" do
        output = send_proofer_output("#{FIXTURES_DIR}/sorting/status", :followlocation => false, :error_sort => :status)
        output.strip.should == """
-1
  *  spec/html/proofer/fixtures/sorting/status/broken_link.html: internally linking to nowhere.fooof, which does not exist
301
  *  spec/html/proofer/fixtures/sorting/status/missing_redirect.html: External link https://help.github.com/changing-author-info/ failed: 301 No error
404
  *  spec/html/proofer/fixtures/sorting/status/broken_link.html: External link http://upload.wikimedia.org/wikipedia/en/thumb/fooooof.png failed: 404 No error
  *  spec/html/proofer/fixtures/sorting/status/a_404.html: External link http://upload.wikimedia.org/wikipedia/en/thumb/not_here.png failed: 404 No error
      """.strip
      end
    end
  end
end
