require 'spec_helper'

describe 'Html test' do
  it 'ignores an invalid tag by default' do
    html = "#{FIXTURES_DIR}/html/invalid_tag.html"
    proofer = run_proofer(html)
    expect(proofer.failed_tests).to eq []
  end

  it "doesn't fail for html5 tags" do
    html = "#{FIXTURES_DIR}/html/html5_tags.html"
    proofer = run_proofer(html, { :check_html => true })
    expect(proofer.failed_tests).to eq []
  end

  it "doesn't fail for svg elements" do
    html = "#{FIXTURES_DIR}/html/svg_elements.html"
    proofer = run_proofer(html, { :check_html => true })
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for an invalid tag' do
    html = "#{FIXTURES_DIR}/html/invalid_tag.html"
    proofer = run_proofer(html, { :check_html => true })
    expect(proofer.failed_tests.first).to match(/Tag myfancytag invalid \(line 2\)/)
  end

  it 'fails for an unmatched end tag' do
    html = "#{FIXTURES_DIR}/html/unmatched_end_tag.html"
    proofer = run_proofer(html, { :check_html => true })
    expect(proofer.failed_tests.first).to match(/Unexpected end tag : div \(line 3\)/)
  end

  it 'fails for an unescaped ampersand in attribute' do
    html = "#{FIXTURES_DIR}/html/unescaped_ampersand_in_attribute.html"
    proofer = run_proofer(html, { :check_html => true })
    expect(proofer.failed_tests.first).to match(/htmlParseEntityRef: expecting ';' \(line 2\)/)
  end

  it 'fails for mismatch between opening and ending tag' do
    html = "#{FIXTURES_DIR}/html/opening_and_ending_tag_mismatch.html"
    proofer = run_proofer(html, { :check_html => true })
    expect(proofer.failed_tests.first).to match(/Opening and ending tag mismatch: p and strong/)
  end

  it 'fails for div inside head' do
    html = "#{FIXTURES_DIR}/html/div_inside_head.html"
    proofer = run_proofer(html, { :check_html => true })
    expect(proofer.failed_tests.first).to match(/Unexpected end tag : head \(line 5\)/)
  end

  it 'fails for missing closing quotation mark in href' do
    html = "#{FIXTURES_DIR}/html/missing_closing_quotes.html"
    proofer = run_proofer(html, { :check_html => true })
    expect(proofer.failed_tests.to_s).to match(/Couldn't find end of Start Tag a \(line 6\)/)
  end

  it 'ignores embeded scripts when asked' do
    opts = { :check_html => true, :validation => { :ignore_script_embeds => true } }
    ignorableScript = "#{FIXTURES_DIR}/html/ignore_script_embeds.html"
    proofer = run_proofer(ignorableScript, opts)
    expect(proofer.failed_tests).to eq []
  end

  it 'does not fail for weird iframe sources' do
    opts = { :check_html => true }
    weird_iframe = "#{FIXTURES_DIR}/html/weird_iframe.html"
    proofer = run_proofer(weird_iframe, opts)
    expect(proofer.failed_tests).to eq []
  end

  it 'does not fail for weird onclick sources' do
    opts = { :check_html => true }
    weird_onclick = "#{FIXTURES_DIR}/html/weird_onclick.html"
    proofer = run_proofer(weird_onclick, opts)
    expect(proofer.failed_tests).to eq []
  end

  it 'validates normal looking government HTML' do
    opts = { :check_html => true }
    normal_looking_page = "#{FIXTURES_DIR}/html/normal_looking_page.html"
    proofer = run_proofer(normal_looking_page, opts)
    expect(proofer.failed_tests).to eq []
  end
end
