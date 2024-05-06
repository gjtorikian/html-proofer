# frozen_string_literal: true

require "spec_helper"

describe "CLI" do
  it "works with allow-hash-href" do
    broken = File.join(FIXTURES_DIR, "links", "hash_href.html")
    output = make_bin("--allow-hash-href #{broken}")
    expect(output).to(match("successfully"))
  end

  it "works with no-allow-hash-href" do
    broken = File.join(FIXTURES_DIR, "links", "hash_href.html")
    output = make_bin("--no-allow-hash-href #{broken}")
    expect(output).to(match("failure"))
  end

  it "works with allow-missing-href" do
    missing_link_href_filepath = File.join(FIXTURES_DIR, "links", "missing_link_href.html")
    output = make_bin("--allow-missing-href #{missing_link_href_filepath}")
    expect(output).to(match("successfully"))
  end

  it "works with no-allow-missing-href" do
    missing_link_href_filepath = File.join(FIXTURES_DIR, "links", "missing_link_href.html")
    output = make_bin("--no-allow-missing-href #{missing_link_href_filepath}")
    expect(output).to(match("failure"))
  end

  it "works with as-links" do
    output = make_bin("--as-links www.github.com,foofoofoo.biz")
    expect(output).to(match("1 failure"))
  end

  it "works with checks" do
    external = File.join(FIXTURES_DIR, "links", "file.foo") # this has a broken link
    output = make_bin("--extensions .foo --checks 'Images,Scripts' #{external}")
    expect(output).not_to(match(/Running.+?Links/))
  end

  it "works with check-external-hash" do
    broken_hash_on_the_web = File.join(FIXTURES_DIR, "links", "broken_hash_on_the_web.html")
    output = make_bin("--check-external-hash #{broken_hash_on_the_web}")
    expect(output).to(match("1 failure"))
  end

  it "works with no-check-external-hash" do
    broken_hash_on_the_web = File.join(FIXTURES_DIR, "links", "broken_hash_on_the_web.html")
    output = make_bin("--no-check-external-hash #{broken_hash_on_the_web}")
    expect(output).to(match("successfully"))
  end

  it "works with check-internal-hash" do
    broken_hash_internal_filepath = File.join(FIXTURES_DIR, "links", "broken_hash_internal.html")
    output = make_bin("--check-internal-hash #{broken_hash_internal_filepath}")
    expect(output).to(match("1 failure"))
  end

  it "works with no-check-internal-hash" do
    broken_hash_internal_filepath = File.join(FIXTURES_DIR, "links", "broken_hash_internal.html")
    output = make_bin("--no-check-internal-hash #{broken_hash_internal_filepath}")
    expect(output).to(match("successfully"))
  end

  it "works with check-sri" do
    file = File.join(FIXTURES_DIR, "links", "cors_not_provided.html")
    output = make_bin("--check-sri #{file}")
    expect(output).to(match("2 failures"))
  end

  it "works with no-check-sri" do
    file = File.join(FIXTURES_DIR, "links", "cors_not_provided.html")
    output = make_bin("--no-check-sri #{file}")
    expect(output).to(match("1 failure")) # has other issues, but one less than above
  end

  it "works with directory-index-file" do
    link_pointing_to_directory = File.join(FIXTURES_DIR, "links", "link_pointing_to_directory.html")
    output = make_bin("--directory-index-file index.php #{link_pointing_to_directory}")
    expect(output).to(match("successfully"))
  end

  it "works with disable-external" do
    external = File.join(FIXTURES_DIR, "links", "broken_link_external.html")
    output = make_bin("--disable-external #{external}")
    expect(output).to(match("successfully"))
  end

  it "works with no-disable-external" do
    external = File.join(FIXTURES_DIR, "links", "broken_link_external.html")
    output = make_bin("--no-disable-external #{external}")
    expect(output).to(match("failure"))
  end

  it "works with enforce-https" do
    custom_data_src_check = File.join(FIXTURES_DIR, "images", "src_http.html")
    output = make_bin("#{custom_data_src_check} --enforce-https")
    expect(output).to(match("1 failure"))
  end

  it "works with no-enforce-https" do
    custom_data_src_check = File.join(FIXTURES_DIR, "images", "src_http.html")
    output = make_bin("#{custom_data_src_check} --no-enforce-https")
    expect(output).to(match("successfully"))
  end

  it "works with extensions" do
    external = File.join(FIXTURES_DIR, "links", "file.foo")
    output = make_bin("--extensions .foo #{external}")
    expect(output).to(match("1 failure"))
  end

  it "works with ignore-empty-alt" do
    broken = File.join(FIXTURES_DIR, "images", "empty_image_alt_text.html")
    output = make_bin("--ignore-empty-alt #{broken}")
    expect(output).to(match("successfully"))
  end

  it "works with no-ignore-empty-alt" do
    broken = File.join(FIXTURES_DIR, "images", "empty_image_alt_text.html")
    output = make_bin("--no-ignore-empty-alt #{broken}")
    expect(output).to(match("failure"))
  end

  it "works with ignore-empty-mailto" do
    broken = File.join(FIXTURES_DIR, "links", "blank_mailto_link.html")
    output = make_bin("--ignore-empty-mailto #{broken}")
    expect(output).to(match("successfully"))
  end

  it "works with no-ignore-empty-mailto" do
    broken = File.join(FIXTURES_DIR, "links", "blank_mailto_link.html")
    output = make_bin("--no-ignore-empty-mailto #{broken}")
    expect(output).to(match("failure"))
  end

  it "works with ignore-files (string)" do
    external = File.join(FIXTURES_DIR, "links", "broken_hash_internal.html")
    output = make_bin("--ignore-files #{external} #{external}")
    expect(output).to(match("successfully"))
  end

  it "works with ignore-files (regexp)" do
    external = File.join(FIXTURES_DIR, "links", "broken_hash_internal.html")
    output = make_bin("--ignore-files /_hash_/ #{external}")
    expect(output).to(match("successfully"))
  end

  it "works with ignore-missing-alt" do
    broken = File.join(FIXTURES_DIR, "images", "missing_image_alt.html")
    output = make_bin("--ignore-missing-alt #{broken}")
    expect(output).to(match("successfully"))
  end

  it "works with no-ignore-missing-alt" do
    broken = File.join(FIXTURES_DIR, "images", "missing_image_alt.html")
    output = make_bin("--no-ignore-missing-alt #{broken}")
    expect(output).to(match("failure"))
  end

  it "works with ignore-status-codes" do
    broken = File.join(FIXTURES_DIR, "links", "404_link.html")
    output = make_bin("--ignore-status-codes 404 #{broken}")
    expect(output).to(match("successfully"))
  end

  it "works with ignore-urls" do
    ignorable_links = File.join(FIXTURES_DIR, "links", "ignorable_links_via_options.html")
    output = make_bin("--ignore-urls /^http:///,/sdadsad/,../whaadadt.html #{ignorable_links}")
    expect(output).to(match("successfully"))
  end

  it "works with swap-urls" do
    translated_link = File.join(FIXTURES_DIR, "links", "link_translated_via_href_swap.html")
    output = make_bin(%|--swap-urls "\\A/articles/([\\w-]+):\\1.html" #{translated_link}|)
    expect(output).to(match("successfully"))
  end

  it "works with swap-urls and colon" do
    translated_link = File.join(FIXTURES_DIR, "links", "link_translated_via_href_swap2.html")
    output = make_bin(%(--swap-urls "http\\://www.example.com:" #{translated_link}))
    expect(output).to(match("successfully"))
  end

  it "works with only-4xx" do
    broken_hash_on_the_web = File.join(FIXTURES_DIR, "links", "broken_hash_on_the_web.html")
    output = make_bin("--only-4xx #{broken_hash_on_the_web}")
    expect(output).to(match("successfully"))
  end

  it "works with check-favicon" do
    broken = File.join(FIXTURES_DIR, "favicon", "internal_favicon_broken.html")
    output = make_bin("--checks 'Favicon' #{broken}")
    expect(output).to(match("1 failure"))
  end

  it "works with swap-attributes" do
    custom_data_src_check = File.join(FIXTURES_DIR, "images", "data_src_attribute.html")
    output = make_bin("--swap-attributes '{ \"img\": [[\"data-src\", \"src\"]] }' #{custom_data_src_check}")
    expect(output).to(match("successfully"))
  end

  it "navigates above itself in a subdirectory" do
    real_link = File.join(FIXTURES_DIR, "links", "root_folder/admin/")
    output = make_bin("--root-dir #{File.join(FIXTURES_DIR, "links", "root_folder/")} #{real_link}")
    expect(output).to(match("successfully"))
  end

  context "when including nested options" do
    it "supports typhoeus" do
      link_with_redirect_filepath = File.join(FIXTURES_DIR, "links", "link_with_redirect.html")
      output = make_bin(" --typhoeus '{ \"followlocation\": false }' #{link_with_redirect_filepath}")
      expect(output).to(match(/failed/))
    end

    it "has only one UA" do
      http = make_bin(%|--typhoeus='{"verbose":true,"headers":{"User-Agent":"Mozilla/5.0 (Macintosh; My New User-Agent)"}}' --as-links https://linkedin.com|)
      expect(http.scan("User-Agent: Typhoeus").count).to(eq(0))
      expect(http.scan(%r{User-Agent: Mozilla/5.0 \(Macintosh; My New User-Agent\)}i).count).to(eq(2))
    end

    it "supports hydra" do
      http = make_bin(%(--hydra '{"max_concurrency": 5}' http://www.github.com --as-links))
      expect(http.scan("max_concurrency is invalid").count).to(eq(0))
      expect(http.scan("successfully").count).to(eq(1))
    end
  end

  context "when dealing with cache" do
    it "basically works" do
      new_time = Time.local(2022, 1, 6, 12, 0, 0)
      Timecop.freeze(new_time) do
        http = make_bin(%(--cache '{"timeframe": { "external": "1d"}}' http://www.github.com --as-links))
        expect(http.scan("successfully").count).to(eq(1))
      end
    end
  end
end
