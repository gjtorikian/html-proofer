# frozen_string_literal: true

require "spec_helper"

describe "Failure" do
  describe "#element" do
    it "exposes the element from internal link failures" do
      file = File.join(FIXTURES_DIR, "links", "broken_link_internal.html")
      proofer = run_proofer(file, :file)

      failure = proofer.failed_checks.first
      expect(failure.element).not_to(be_nil)
      expect(failure.element).to(be_a(HTMLProofer::Element))
    end

    it "provides access to the Nokogiri node via element" do
      file = File.join(FIXTURES_DIR, "links", "broken_link_internal.html")
      proofer = run_proofer(file, :file)

      failure = proofer.failed_checks.first
      expect(failure.element.node).to(be_a(Nokogiri::XML::Element))
      expect(failure.element.node.name).to(eq("a"))
    end

    it "exposes element content matching link text" do
      file = File.join(FIXTURES_DIR, "links", "broken_link_internal.html")
      proofer = run_proofer(file, :file)

      failure = proofer.failed_checks.first
      expect(failure.element.content).to(eq("Not a real link!"))
    end

    it "allows access to node attributes" do
      file = File.join(FIXTURES_DIR, "links", "broken_link_internal.html")
      proofer = run_proofer(file, :file)

      failure = proofer.failed_checks.first
      expect(failure.element.node["href"]).to(eq("./notreal.html"))
    end

    it "exposes element for external link failures" do
      file = File.join(FIXTURES_DIR, "links", "broken_link_external.html")
      proofer = run_proofer(file, :file)

      failure = proofer.failed_checks.first
      expect(failure.element).not_to(be_nil)
      expect(failure.element).to(be_a(HTMLProofer::Element))
      expect(failure.element.a_tag?).to(be(true))
    end

    it "exposes element for image check failures" do
      file = File.join(FIXTURES_DIR, "images", "missing_image_alt.html")
      proofer = run_proofer(file, :file)

      failure = proofer.failed_checks.first
      expect(failure.element).not_to(be_nil)
      expect(failure.element.img_tag?).to(be(true))
    end

    it "exposes element for direct check failures with element info" do
      file = File.join(FIXTURES_DIR, "links", "broken_hash_internal.html")
      proofer = run_proofer(file, :file)

      failure = proofer.failed_checks.first
      expect(failure.element).not_to(be_nil)
      expect(failure.element.a_tag?).to(be(true))
    end
  end
end
