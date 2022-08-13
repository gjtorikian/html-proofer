# frozen_string_literal: true

require "spec_helper"

describe HTMLProofer::Attribute::Url do
  before(:each) do
    @runner = HTMLProofer::Runner.new("")
  end

  describe "#ignores_pattern_check" do
    it "works for regex patterns" do
      @runner.options[:ignore_urls] = [%r{/assets/.*(js|css|png|svg)}]
      url = HTMLProofer::Attribute::Url.new(@runner, "/assets/main.js")
      expect(url.ignore?).to(eq(true))
    end

    it "works for string patterns" do
      @runner.options[:ignore_urls] = ["/assets/main.js"]
      url = HTMLProofer::Attribute::Url.new(@runner, "/assets/main.js")
      expect(url.ignore?).to(eq(true))
    end
  end

  describe "#protocol_relative" do
    it "works for protocol relative" do
      url = HTMLProofer::Attribute::Url.new(@runner, "//assets/main.js")
      expect(url.protocol_relative?).to(eq(true))
    end

    it "works for https://" do
      url = HTMLProofer::Attribute::Url.new(@runner, "https://assets/main.js")
      expect(url.protocol_relative?).to(eq(false))
    end

    it "works for http://" do
      url = HTMLProofer::Attribute::Url.new(@runner, "http://assets/main.js")
      expect(url.protocol_relative?).to(eq(false))
    end

    it "works for relative internal link" do
      url = HTMLProofer::Attribute::Url.new(@runner, "assets/main.js")
      expect(url.protocol_relative?).to(eq(false))
    end

    it "works for absolute internal link" do
      url = HTMLProofer::Attribute::Url.new(@runner, "/assets/main.js")
      expect(url.protocol_relative?).to(eq(false))
    end
  end
end
