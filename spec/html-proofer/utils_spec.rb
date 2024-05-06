# frozen_string_literal: true

require "spec_helper"

describe "Utils" do
  describe "::create_nokogiri" do
    include HTMLProofer::Utils

    it "passes for a string" do
      noko = create_nokogiri('<html lang="jp">')
      expect(noko.css("html").first["lang"]).to(eq("jp"))
    end

    it "passes for a file" do
      noko = create_nokogiri(File.join(FIXTURES_DIR, "utils", "lang-jp.html"))
      expect(noko.css("html").first["lang"]).to(eq("jp"))
    end

    it "ignores directories" do
      noko = create_nokogiri(File.join(FIXTURES_DIR, "utils"))
      expect(noko.content).to(eq(File.join("spec", "html-proofer", "fixtures", "utils")))
    end
  end
end
