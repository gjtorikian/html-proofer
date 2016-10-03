require 'spec_helper'

describe 'Html test' do
  it 'ignores an invalid tag by default' do
    html = "#{FIXTURES_DIR}/html/invalid_tag.html"
    proofer = run_proofer(html, :file)
    expect(proofer.failed_tests).to eq []
  end

  it "doesn't fail for html5 tags" do
    html = "#{FIXTURES_DIR}/html/html5_tags.html"
    proofer = run_proofer(html, :file, { :check_html => true })
    expect(proofer.failed_tests).to eq []
  end

  it "doesn't fail for svg elements" do
    html = "#{FIXTURES_DIR}/html/svg_elements.html"
    proofer = run_proofer(html, :file, { :check_html => true })
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for an invalid tag' do
    html = "#{FIXTURES_DIR}/html/invalid_tag.html"
    proofer = run_proofer(html, :file, { :check_html => true, :validation => { :report_invalid_tags => true} })
    expect(proofer.failed_tests.first).to match(/Tag myfancytag invalid \(line 2\)/)
  end

  it 'fails for an unmatched end tag' do
    html = "#{FIXTURES_DIR}/html/unmatched_end_tag.html"
    proofer = run_proofer(html, :file, { :check_html => true })
    expect(proofer.failed_tests.first).to match(/Unexpected end tag : div \(line 3\)/)
  end

  it 'fails for an unescaped ampersand in attribute' do
    html = "#{FIXTURES_DIR}/html/unescaped_ampersand_in_attribute.html"
    proofer = run_proofer(html, :file, { :check_html => true })
    expect(proofer.failed_tests.first).to match(/htmlParseEntityRef: expecting ';' \(line 2\)/)
  end

  it 'fails for mismatch between opening and ending tag' do
    html = "#{FIXTURES_DIR}/html/opening_and_ending_tag_mismatch.html"
    proofer = run_proofer(html, :file, { :check_html => true })
    expect(proofer.failed_tests.first).to match(/Opening and ending tag mismatch: p and strong/)
  end

  it 'fails for div inside head' do
    html = "#{FIXTURES_DIR}/html/div_inside_head.html"
    proofer = run_proofer(html, :file, { :check_html => true })
    expect(proofer.failed_tests.first).to match(/Unexpected end tag : head \(line 5\)/)
  end

  it 'fails for missing closing quotation mark in href' do
    html = "#{FIXTURES_DIR}/html/missing_closing_quotes.html"
    proofer = run_proofer(html, :file, { :check_html => true })
    expect(proofer.failed_tests.to_s).to match(/Couldn't find end of Start Tag a \(line 6\)/)
  end

  it "doesn't fail for single ampersand" do
    html = "#{FIXTURES_DIR}/html/single_amp.html"
    proofer = run_proofer(html, :file, { :check_html => true })
    expect(proofer.failed_tests).to eq []
  end

  it "fails for single ampersand when asked" do
    html = "#{FIXTURES_DIR}/html/single_amp.html"
    proofer = run_proofer(html, :file, { :check_html => true, :validation => { :report_missing_names => true } })
    expect(proofer.failed_tests.first).to match('htmlParseEntityRef: no name')
  end

  it 'ignores embeded scripts when asked' do
    opts = { :check_html => true, :validation => { :report_script_embeds => false } }
    ignorableScript = "#{FIXTURES_DIR}/html/ignore_script_embeds.html"
    proofer = run_proofer(ignorableScript, :file, opts)
    expect(proofer.failed_tests).to eq []
  end

  it 'reports embeded scripts when asked' do
    opts = { :check_html => true, :validation => { :report_script_embeds => true } }
    ignorableScript = "#{FIXTURES_DIR}/html/ignore_script_embeds.html"
    proofer = run_proofer(ignorableScript, :file, opts)
    expect(proofer.failed_tests.length).to eq 2
  end

  it 'does not fail for weird iframe sources' do
    opts = { :check_html => true }
    weird_iframe = "#{FIXTURES_DIR}/html/weird_iframe.html"
    proofer = run_proofer(weird_iframe, :file, opts)
    expect(proofer.failed_tests).to eq []
  end

  it 'does not fail for weird onclick sources' do
    opts = { :check_html => true }
    weird_onclick = "#{FIXTURES_DIR}/html/weird_onclick.html"
    proofer = run_proofer(weird_onclick, :file, opts)
    expect(proofer.failed_tests).to eq []
  end

  it 'validates normal looking government HTML' do
    opts = { :check_html => true }
    normal_looking_page = "#{FIXTURES_DIR}/html/normal_looking_page.html"
    proofer = run_proofer(normal_looking_page, :file, opts)
    expect(proofer.failed_tests).to eq []
  end

  it 'does not fail for tag picture' do
    opts = { :check_html => true }
    normal_looking_page = "#{FIXTURES_DIR}/html/tag_picture.html"
    proofer = run_proofer(normal_looking_page, :file, opts)
    expect(proofer.failed_tests).to eq []
  end

  it 'ignores namespaces' do
    opts = { :check_html => true }
    ignorableNamespace = "#{FIXTURES_DIR}/html/ignore_namespace.html"
    proofer = run_proofer(ignorableNamespace, :file, opts)
    expect(proofer.failed_tests).to eq []
  end
end
