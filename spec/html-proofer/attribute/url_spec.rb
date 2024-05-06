# frozen_string_literal: true

require "spec_helper"

describe "Attribute::Url" do
  let(:runner) { HTMLProofer::Runner.new("") }
  let(:described_class) { HTMLProofer::Attribute::Url }

  describe "#ignores_pattern_check" do
    it "works for regex patterns" do
      runner.options[:ignore_urls] = [%r{/assets/.*(js|css|png|svg)}]
      url = described_class.new(runner, "/assets/main.js")
      expect(url.ignore?).to(be(true))
    end

    it "works for string patterns" do
      runner.options[:ignore_urls] = ["/assets/main.js"]
      url = described_class.new(runner, "/assets/main.js")
      expect(url.ignore?).to(be(true))
    end
  end

  describe "#protocol_relative" do
    it "works for protocol relative" do
      url = described_class.new(runner, "//assets/main.js")
      expect(url.protocol_relative?).to(be(true))
    end

    it "works for https://" do
      url = described_class.new(runner, "https://assets/main.js")
      expect(url.protocol_relative?).to(be(false))
    end

    it "works for http://" do
      url = described_class.new(runner, "http://assets/main.js")
      expect(url.protocol_relative?).to(be(false))
    end

    it "works for relative internal link" do
      url = described_class.new(runner, "assets/main.js")
      expect(url.protocol_relative?).to(be(false))
    end

    it "works for absolute internal link" do
      url = described_class.new(runner, "/assets/main.js")
      expect(url.protocol_relative?).to(be(false))
    end
  end
end
