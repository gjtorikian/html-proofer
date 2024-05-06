# frozen_string_literal: true

require "spec_helper"

describe "Element" do
  let(:runner) { HTMLProofer::Runner.new("") }
  let(:described_class) { HTMLProofer::Element }

  describe "#initialize" do
    it "accepts the xmlns attribute" do
      nokogiri = Nokogiri::HTML5('<a xmlns:cc="http://creativecommons.org/ns#">Creative Commons</a>')
      element = described_class.new(runner, nokogiri.css("a").first)
      expect(element.node["xmlns:cc"]).to(eq("http://creativecommons.org/ns#"))
    end

    it "assignes the text node" do
      nokogiri = Nokogiri::HTML5("<p>One")
      element = described_class.new(runner, nokogiri.css("p").first)
      expect(element.node.text).to(eq("One"))
      expect(element.node.content).to(eq("One"))
    end

    it "accepts the content attribute" do
      nokogiri = Nokogiri::HTML5('<meta name="twitter:card" content="summary">')
      element = described_class.new(runner, nokogiri.css("meta").first)
      expect(element.node["content"]).to(eq("summary"))
    end
  end

  describe "#link_attribute" do
    it "works for src attributes" do
      nokogiri = Nokogiri::HTML5("<img src=image.png />")
      element = described_class.new(runner, nokogiri.css("img").first)
      expect(element.url.to_s).to(eq("image.png"))
    end
  end

  describe "#ignore" do
    it "works for twitter cards" do
      nokogiri = Nokogiri::HTML5('<meta name="twitter:url" data-proofer-ignore content="http://example.com/soon-to-be-published-url">')
      element = described_class.new(runner, nokogiri.css("meta").first)
      expect(element.ignore?).to(be(true))
    end
  end

  describe "ivar setting" do
    it "does not explode if given a bad attribute" do
      broken_attribute = File.join(FIXTURES_DIR, "html", "invalid_attribute.html")
      proofer = run_proofer(broken_attribute, :file)
      expect(proofer.failed_checks.length).to(eq(0))
    end
  end
end
