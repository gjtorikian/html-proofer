# frozen_string_literal: true

require 'spec_helper'

describe HTMLProofer do
  describe '#failed_checks' do
    it 'is an array of Failures' do
      broken_link_internal_filepath = File.join(FIXTURES_DIR, 'links', 'broken_link_internal.html')
      proofer = run_proofer(broken_link_internal_filepath, :file)
      expect(proofer.failed_checks.length).to eq(2)
      expect(proofer.failed_checks[0].class).to eq(HTMLProofer::Failure)
      expect(proofer.failed_checks.first.path).to eq(broken_link_internal_filepath)
      expect(proofer.failed_checks.first.description).to eq('internally linking to ./notreal.html, which does not exist')
      expect(proofer.failed_checks.first.line).to eq(3)
    end
  end

  describe '#files' do
    it 'works for directory that ends with .html' do
      folder = File.join(FIXTURES_DIR, 'links', '_site/folder.html')
      proofer = HTMLProofer.check_directory(folder)
      expect(proofer.files).to eq([{ source: folder, path: "#{folder}/index.html" }])
    end
  end

  describe '#options' do
    it 'strips out undesired Typhoeus options' do
      folder = File.join(FIXTURES_DIR, 'links', '_site/folder.html')
      proofer = HTMLProofer.check_file(folder, verbose: true)
      expect(proofer.options[:verbose]).to eq(true)
      expect(proofer.options[:typhoeus][:verbose]).to eq(nil)
    end

    it 'takes options for Parallel' do
      folder = File.join(FIXTURES_DIR, 'links', '_site/folder.html')
      proofer = HTMLProofer.check_file(folder, parallel: { in_processes: 3 })
      expect(proofer.options[:parallel][:in_processes]).to eq(3)
      expect(proofer.options[:typhoeus][:in_processes]).to eq(nil)
    end

    it 'only has one UA with file' do
      github_hash = File.join(FIXTURES_DIR, 'links', 'github_hash.html')
      http = capture_proofer_http(github_hash, :file, typhoeus: { verbose: true, headers: { 'User-Agent' => 'Mozilla/5.0 (compatible; My New User-Agent)' } })
      expect(http['request']['headers']['User-Agent']).to eq(['Mozilla/5.0 (compatible; My New User-Agent)'])
    end
  end

  describe 'file ignores' do
    it 'knows how to ignore a file by string' do
      options = { ignore_files: [File.join(FIXTURES_DIR, 'links', 'broken_hash_internal.html')] }
      broken_hash_internal_filepath = File.join(FIXTURES_DIR, 'links', 'broken_hash_internal.html')
      proofer = run_proofer(broken_hash_internal_filepath, :file, options)
      expect(proofer.failed_checks).to eq([])
    end

    it 'knows how to ignore a file by regexp' do
      options = { ignore_files: [/broken_hash/] }
      broken_hash_internal_filepath = File.join(FIXTURES_DIR, 'links', 'broken_hash_internal.html')
      proofer = run_proofer(broken_hash_internal_filepath, :file, options)
      expect(proofer.failed_checks).to eq([])
    end

    it 'knows how to ignore multiple files by regexp' do
      options = { ignore_files: [%r{.*/javadoc/.*}, %r{.*/catalog/.*}] }
      broken_folders = File.join(FIXTURES_DIR, 'links', 'folder/multiples')
      proofer = run_proofer([broken_folders], :directories, options)
      expect(proofer.failed_checks).to eq([])
    end

    it 'knows how to ignore a directory by regexp' do
      options = { ignore_files: [/\S\.html/] }
      links_dir = File.join(FIXTURES_DIR, 'links')
      proofer = run_proofer([links_dir], :directories, options)
      expect(proofer.failed_checks).to eq([])
    end
  end

  describe 'ignored checks' do
    it 'knows how to ignore checks' do
      options = { checks_to_ignore: ['ImageRunner'] }
      proofer = make_proofer(File.join(FIXTURES_DIR, 'links', 'broken_link_external.html'), :file, options)
      expect(proofer.checks).to_not include 'ImageRunner'
    end

    it 'does not care about phoney ignored checks' do
      options = { checks_to_ignore: ['This is nothing.'] }
      proofer = make_proofer(File.join(FIXTURES_DIR, 'links', 'broken_link_external.html'), :file, options)
      expect(proofer.checks.length).to eq(3)
    end
  end

  describe 'external links' do
    it 'ignores status codes when asked' do
      proofer = run_proofer(['www.github.com/github/notreallyhere'], :links, ignore_status_codes: [404])
      expect(proofer.failed_checks.length).to eq(0)
    end
  end

  describe 'multiple directories' do
    it 'works' do
      dirs = [File.join(FIXTURES_DIR, 'links'), File.join(FIXTURES_DIR, 'images')]
      output = capture_proofer_output(dirs, :directories)

      expect(output).to match(File.join(FIXTURES_DIR, 'links'))
      expect(output).to match(File.join(FIXTURES_DIR, 'images'))
    end
  end
end
