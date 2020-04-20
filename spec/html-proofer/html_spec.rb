# frozen_string_literal: true

require 'spec_helper'

describe 'Html test' do
  it 'ignores an invalid tag by default' do
    html = "#{FIXTURES_DIR}/html/invalid_tag.html"
    proofer = run_proofer(html, :file)
    expect(proofer.failed_tests).to eq []
  end

  it "doesn't fail for html5 tags" do
    html = "#{FIXTURES_DIR}/html/html5_tags.html"
    proofer = run_proofer(html, :file, check_html: true)
    expect(proofer.failed_tests).to eq []
  end

  it "doesn't fail for svg elements" do
    html = "#{FIXTURES_DIR}/html/svg_elements.html"
    proofer = run_proofer(html, :file, check_html: true)
    expect(proofer.failed_tests).to eq []
  end

  it 'works for custom tags' do
    html = "#{FIXTURES_DIR}/html/invalid_tag.html"
    proofer = run_proofer(html, :file, check_html: true, validation: { report_invalid_tags: true })
    expect(proofer.failed_tests).to eq []
  end

  it 'allows an unmatched end tag' do
    html = "#{FIXTURES_DIR}/html/unmatched_end_tag.html"
    proofer = run_proofer(html, :file, check_html: true)
    expect(proofer.failed_tests).to eq []
  end

  it 'allows an unescaped ampersand in attribute' do
    html = "#{FIXTURES_DIR}/html/unescaped_ampersand_in_attribute.html"
    proofer = run_proofer(html, :file, check_html: true)
    expect(proofer.failed_tests).to eq []
  end

  it 'allows mismatch between opening and ending tag' do
    html = "#{FIXTURES_DIR}/html/opening_and_ending_tag_mismatch.html"
    proofer = run_proofer(html, :file, check_html: true)
    expect(proofer.failed_tests).to eq []
  end

  it 'allows div inside head' do
    html = "#{FIXTURES_DIR}/html/div_inside_head.html"
    proofer = run_proofer(html, :file, check_html: true)
    expect(proofer.failed_tests).to eq []
  end

  it 'allows missing closing quotation mark in href' do
    html = "#{FIXTURES_DIR}/html/missing_closing_quotes.html"
    proofer = run_proofer(html, :file, check_html: true)
    expect(proofer.failed_tests).to eq []
  end

  it "doesn't fail for single ampersand" do
    html = "#{FIXTURES_DIR}/html/single_amp.html"
    proofer = run_proofer(html, :file, check_html: true)
    expect(proofer.failed_tests).to eq []
  end

  it 'allows single ampersand' do
    html = "#{FIXTURES_DIR}/html/single_amp.html"
    proofer = run_proofer(html, :file, check_html: true, validation: { report_missing_names: true })
    expect(proofer.failed_tests).to eq []
  end

  it 'ignores embeded scripts when asked' do
    opts = { check_html: true, validation: { report_script_embeds: false } }
    ignorable_script = "#{FIXTURES_DIR}/html/ignore_script_embeds.html"
    proofer = run_proofer(ignorable_script, :file, opts)
    expect(proofer.failed_tests).to eq []
  end

  it 'reports embeded scripts when asked' do
    opts = { check_html: true, validation: { report_script_embeds: true } }
    ignorable_script = "#{FIXTURES_DIR}/html/ignore_script_embeds.html"
    proofer = run_proofer(ignorable_script, :file, opts)
    expect(proofer.failed_tests).to eq []
  end

  it 'does not fail for weird iframe sources' do
    opts = { check_html: true }
    weird_iframe = "#{FIXTURES_DIR}/html/weird_iframe.html"
    proofer = run_proofer(weird_iframe, :file, opts)
    expect(proofer.failed_tests).to eq []
  end

  it 'does not fail for weird onclick sources' do
    opts = { check_html: true }
    weird_onclick = "#{FIXTURES_DIR}/html/weird_onclick.html"
    proofer = run_proofer(weird_onclick, :file, opts)
    expect(proofer.failed_tests).to eq []
  end

  it 'validates normal looking government HTML' do
    opts = { check_html: true }
    normal_looking_page = "#{FIXTURES_DIR}/html/normal_looking_page.html"
    proofer = run_proofer(normal_looking_page, :file, opts)
    expect(proofer.failed_tests).to eq []
  end

  it 'does not fail for tag picture' do
    opts = { check_html: true }
    normal_looking_page = "#{FIXTURES_DIR}/html/tag_picture.html"
    proofer = run_proofer(normal_looking_page, :file, opts)
    expect(proofer.failed_tests).to eq []
  end

  it 'ignores namespaces' do
    opts = { check_html: true }
    ignorable_namespace = "#{FIXTURES_DIR}/html/ignore_namespace.html"
    proofer = run_proofer(ignorable_namespace, :file, opts)
    expect(proofer.failed_tests).to eq []
  end

  it 'passes for scripts with ampersands' do
    opts = { check_html: true }
    file = "#{FIXTURES_DIR}/html/parse_error.html"
    proofer = run_proofer(file, :file, opts)
    expect(proofer.failed_tests).to eq []
  end

  it 'reports failures' do
    opts = { check_html: true, validation: { report_mismatched_tags: true } }
    file = "#{FIXTURES_DIR}/html/parse_failure.html"
    proofer = run_proofer(file, :file, opts)
    expect(proofer.failed_tests.first).to match(/ERROR: That tag isn't allowed here/)
  end
end
