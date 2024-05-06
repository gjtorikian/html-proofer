# frozen_string_literal: true

require "spec_helper"
require "html-proofer"

describe "Configuration" do
  let(:described_class) { HTMLProofer::Configuration }

  it "Throws an error when the option name is not a string" do
    expect do
      described_class.new.parse_json_option(
        123,
        "",
      )
    end.to(raise_error(ArgumentError, "Must provide an option name in string format."))
  end

  it "Throws an error when the option name is empty" do
    expect do
      described_class.new.parse_json_option(
        "",
        "{}",
      )
    end.to(raise_error(ArgumentError, "Must provide an option name in string format."))
  end

  it "Throws an error when the option name is whitespace" do
    expect do
      described_class.new.parse_json_option(
        "    ",
        "{}",
      )
    end.to(raise_error(ArgumentError, "Must provide an option name in string format."))
  end

  it "Throws an error when the json config is not a string" do
    expect do
      described_class.new.parse_json_option(
        "testName",
        123,
      )
    end.to(raise_error(ArgumentError, "Must provide a JSON configuration in string format."))
  end

  it "returns an empty options object when config is nil" do
    result = described_class.new.parse_json_option("testName", nil)
    expect(result).to(eq({}))
  end

  it "returns an empty options object when config is empty" do
    result = described_class.new.parse_json_option("testName", "")
    expect(result).to(eq({}))
  end

  it "returns an empty options object when config is whitespace" do
    result = described_class.new.parse_json_option("testName", "    ")
    expect(result).to(eq({}))
  end

  it "Returns an object representing the json when valid json" do
    result = described_class.new.parse_json_option(
      "testName",
      '{ "myValue": "hello world!", "numberValue": 123}',
    )
    expect(result[:myValue]).to(eq("hello world!"))
    expect(result[:numberValue]).to(eq(123))
  end

  it "Throws an error when the json config is not valid json" do
    expect { described_class.new.parse_json_option("testName", "abc") }.to(raise_error(ArgumentError))
  end
end
