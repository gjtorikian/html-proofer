require "spec_helper"

describe HTML::Proofer do

  describe "#failed_tests" do
    it "is a list of the formatted errors" do
      brokenLinkInternalFilepath = "#{FIXTURES_DIR}/links/brokenLinkInternal.html"
      proofer = HTML::Proofer.new(brokenLinkInternalFilepath)
      capture_stderr { proofer.run }
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
      proofer = HTML::Proofer.new folder, :parallel_opts => { :in_processes => 3 }
      proofer.options[:parallel_opts][:in_processes].should == 3
      proofer.typhoeus_opts[:in_processes].should == nil
    end
  end
end
