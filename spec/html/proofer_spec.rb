require "spec_helper"

describe HTML::Proofer do

  describe '#failed_tests' do
    it 'is a list of the formatted errors' do
      brokenLinkInternalFilepath = "#{FIXTURES_DIR}/links/brokenLinkInternal.html"
      proofer = run_proofer(brokenLinkInternalFilepath)
      expect(proofer.failed_tests).to eq(["spec/html/proofer/fixtures/links/brokenLinkInternal.html: internally linking to ./notreal.html, which does not exist (line 5)", "spec/html/proofer/fixtures/links/brokenLinkInternal.html: internally linking to ./missingImageAlt.html, which does not exist (line 6)"])
    end
  end

  describe '#files' do
    it 'works for directory that ends with .html' do
      folder = "#{FIXTURES_DIR}/links/_site/folder.html"
      proofer = HTML::Proofer.new folder
      expect(proofer.files).to eq(["#{folder}/index.html"])
    end
  end

  describe '#options' do
    it 'strips out undesired Typhoeus options' do
      folder = "#{FIXTURES_DIR}/links/_site/folder.html"
      proofer = HTML::Proofer.new folder, :verbose => true
      expect(proofer.options[:verbose]).to eq(true)
      expect(proofer.typhoeus_opts[:verbose]).to eq(nil)
    end

    it 'takes options for Parallel' do
      folder = "#{FIXTURES_DIR}/links/_site/folder.html"
      proofer = HTML::Proofer.new folder, :parallel => { :in_processes => 3 }
      expect(proofer.parallel_opts[:in_processes]).to eq(3)
      expect(proofer.typhoeus_opts[:in_processes]).to eq(nil)
      expect(proofer.options[:parallel]).to eq(nil)
    end

    describe 'sorting' do
      it 'understands sorting by path' do
        output = send_proofer_output("#{FIXTURES_DIR}/sorting/path")

        expect(output.strip).to eq('''
- spec/html/proofer/fixtures/sorting/path/multiple_issues.html
  *  image gpl.png does not have an alt attribute (line 7)
  *  internal image gpl.png does not exist (line 7)
  *  tel: contains no phone number (line 5)
- spec/html/proofer/fixtures/sorting/path/single_issue.html
  *  image has a terrible filename (./Screen Shot 2012-08-09 at 7.51.18 AM.png) (line 1)
      '''.strip)
      end

      it 'understands sorting by issue' do
        output = send_proofer_output("#{FIXTURES_DIR}/sorting/issue", :error_sort => :desc)
        expect(output.strip).to eq('''
- image ./gpl.png does not have an alt attribute
  *  spec/html/proofer/fixtures/sorting/issue/broken_image_one.html (line 1)
  *  spec/html/proofer/fixtures/sorting/issue/broken_image_two.html (line 1)
- internal image ./gpl.png does not exist
  *  spec/html/proofer/fixtures/sorting/issue/broken_image_one.html (line 1)
  *  spec/html/proofer/fixtures/sorting/issue/broken_image_two.html (line 1)
- internal image NOT_AN_IMAGE does not exist
  *  spec/html/proofer/fixtures/sorting/issue/broken_image_two.html (line 4)
      '''.strip)
      end


      it 'understands sorting by status' do
        output = send_proofer_output("#{FIXTURES_DIR}/sorting/status", :typhoeus => { :followlocation => false }, :error_sort => :status)
        expect(output.strip).to eq('''
- -1
  *  spec/html/proofer/fixtures/sorting/status/broken_link.html: internally linking to nowhere.fooof, which does not exist (line 3)
- 404
  *  spec/html/proofer/fixtures/sorting/status/a_404.html: External link http://upload.wikimedia.org/wikipedia/en/thumb/not_here.png failed: 404 No error
  *  spec/html/proofer/fixtures/sorting/status/broken_link.html: External link http://upload.wikimedia.org/wikipedia/en/thumb/fooooof.png failed: 404 No error
    '''.strip)
      end
    end

    describe 'file ignores' do
      it 'knows how to ignore a file by string' do
        options = { :file_ignore => ["#{FIXTURES_DIR}/links/brokenHashInternal.html"] }
        brokenHashInternalFilepath = "#{FIXTURES_DIR}/links/brokenHashInternal.html"
        proofer = run_proofer(brokenHashInternalFilepath, options)
        expect(proofer.failed_tests).to eq []
      end

      it 'knows how to ignore a file by regexp' do
        options = { :file_ignore => [/brokenHash/] }
        brokenHashInternalFilepath = "#{FIXTURES_DIR}/links/brokenHashInternal.html"
        proofer = run_proofer(brokenHashInternalFilepath, options)
        expect(proofer.failed_tests).to eq []
      end

      it 'knows how to ignore multiple files by regexp' do
        options = { :file_ignore => [%r{.*/javadoc/.*}, %r{.*/catalog/.*}] }
        brokenFolders = "#{FIXTURES_DIR}/links/folder/multiples"
        proofer = run_proofer(brokenFolders, options)
        expect(proofer.failed_tests).to eq []
      end

      it 'knows how to ignore a directory by regexp' do
        options = { :file_ignore => [/\S\.html/] }
        linksDir = "#{FIXTURES_DIR}/links"
        proofer = run_proofer(linksDir, options)
        expect(proofer.failed_tests).to eq []
      end
    end
  end

  describe 'ignored checks' do
    it 'knows how to ignore checks' do
      options = { :checks_to_ignore => ['ImageRunner'] }
      proofer = make_proofer('', options)
      expect(proofer.checks).to_not include 'ImageRunner'
    end

    it 'does not care about phoney ignored checks' do
      options = { :checks_to_ignore => ['This is nothing.'] }
      proofer = make_proofer('', options)
      expect(proofer.checks.length).to eq 3
    end
  end
end
