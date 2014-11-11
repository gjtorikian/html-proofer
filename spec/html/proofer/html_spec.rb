require "spec_helper"

describe "Html test" do
  it "ignores an invalid tag by default" do
    html = "#{FIXTURES_DIR}/html/invalid_tag.html"
    output = capture_stderr { HTML::Proofer.new(html).run }
    expect(output).to eq ""
  end

  it "doesn't fail for html5 tags" do
    html = "#{FIXTURES_DIR}/html/html5_tags.html"
    output = capture_stderr { HTML::Proofer.new(html, {:validate_html => true}).run }
    expect(output).to eq ""
  end

  it "fails for an invalid tag" do
    html = "#{FIXTURES_DIR}/html/invalid_tag.html"
    output = capture_stderr { HTML::Proofer.new(html, {:validate_html => true}).run }
    expect(output).to match /Tag myfancytag invalid/
  end

  it "fails for an unmatched end tag" do
    html = "#{FIXTURES_DIR}/html/unmatched_end_tag.html"
    output = capture_stderr { HTML::Proofer.new(html, {:validate_html => true}).run }
    expect(output).to match /Unexpected end tag : div/
  end

  it "fails for an unescaped ampersand in attribute" do
    html = "#{FIXTURES_DIR}/html/unescaped_ampersand_in_attribute.html"
    output = capture_stderr { HTML::Proofer.new(html, {:validate_html => true}).run }
    expect(output).to match /htmlParseEntityRef: expecting ';'/
  end

  it "fails for mismatch between opening and ending tag" do
    html = "#{FIXTURES_DIR}/html/opening_and_ending_tag_mismatch.html"
    output = capture_stderr { HTML::Proofer.new(html, {:validate_html => true}).run }
    expect(output).to match /Opening and ending tag mismatch: p and strong/
  end

  it "fails for div inside head" do
    html = "#{FIXTURES_DIR}/html/div_inside_head.html"
    output = capture_stderr { HTML::Proofer.new(html, {:validate_html => true}).run }
    expect(output).to match /Unexpected end tag : head/
  end

  it "fails for missing closing quotation mark in href" do
    html = "#{FIXTURES_DIR}/html/missing_closing_quotes.html"
    output = capture_stderr { HTML::Proofer.new(html, {:validate_html => true}).run }
    expect(output).to match /Couldn't find end of Start Tag a/
  end
end
