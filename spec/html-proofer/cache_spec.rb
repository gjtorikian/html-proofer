# frozen_string_literal: true

require "spec_helper"

describe "Cache" do
  let(:cache_fixture_dir) { File.join(FIXTURES_DIR, "cache") }

  let(:default_cache_options) { { storage_dir: cache_fixture_dir } }

  let(:file_runner) { HTMLProofer.check_file(test_file, runner_options) }
  let(:link_runner) { HTMLProofer.check_links(links, runner_options) }

  let(:described_class) { HTMLProofer::Cache }

  def read_cache(cache_filename)
    JSON.parse(File.read(File.join(cache_fixture_dir, cache_filename)))
  end

  context "when parsing time" do
    let(:links) { ["www.github.com"] }
    let(:runner_options) { default_cache_options }

    it "understands months" do
      now_time = Time.local(2019, 9, 6, 12, 0, 0)
      Timecop.freeze(now_time) do
        cache = described_class.new(link_runner, timeframe: { external: "2M" })

        check_time = Time.local(2019, 8, 6, 12, 0, 0).to_s

        expect(cache.within_external_timeframe?(check_time)).to(be(true))

        check_time = Time.local(2019, 5, 6, 12, 0, 0).to_s

        expect(cache.within_external_timeframe?(check_time)).to(be(false))
      end
    end

    it "understands days" do
      now_time = Time.local(2019, 9, 6, 12, 0, 0)
      Timecop.freeze(now_time) do
        cache = described_class.new(link_runner, timeframe: { external: "2d" })

        check_time = Time.local(2019, 9, 5, 12, 0, 0).to_s

        expect(cache.within_external_timeframe?(check_time)).to(be(true))

        check_time = Time.local(2019, 5, 6, 12, 0, 0).to_s

        expect(cache.within_external_timeframe?(check_time)).to(be(false))
      end
    end

    it "understands weeks" do
      now_time = Time.local(2019, 9, 6, 12, 0, 0)
      Timecop.freeze(now_time) do
        cache = described_class.new(link_runner, timeframe: { external: "2w" })

        check_time = Time.local(2019, 8, 30, 12, 0, 0).to_s

        expect(cache.within_external_timeframe?(check_time)).to(be(true))

        check_time = Time.local(2019, 5, 6, 12, 0, 0).to_s

        expect(cache.within_external_timeframe?(check_time)).to(be(false))
      end
    end

    it "understands hours" do
      now_time = Time.local(2019, 9, 6, 12, 0, 0)
      Timecop.freeze(now_time) do
        cache = described_class.new(link_runner, timeframe: { external: "3h" })

        check_time = Time.local(2019, 9, 6, 9, 0, 0).to_s

        expect(cache.within_external_timeframe?(check_time)).to(be(true))

        check_time = Time.local(2019, 5, 6, 12, 0, 0).to_s

        expect(cache.within_external_timeframe?(check_time)).to(be(false))
      end
    end

    it "fails on an invalid date" do
      file = File.join(FIXTURES_DIR, "links", "broken_link_external.html")
      expect do
        run_proofer(file, :file, cache: { timeframe: { external: "30x" } }.merge(default_cache_options))
      end.to(raise_error(ArgumentError))
    end
  end

  context "with version 2" do
    let(:version) { "version_2" }

    it "knows how to write to cache" do
      test_file = File.join(cache_fixture_dir, "internal_and_external_example.html")
      cache_filename = File.join(version, ".htmlproofer_test.json")
      cache_filepath = File.join(cache_fixture_dir, cache_filename)

      File.delete(cache_filepath) if File.exist?(cache_filepath)

      allow(described_class).to(receive(:write).once)
      run_proofer(
        test_file,
        :file,
        cache: { timeframe: { external: "30d", internal: "30d" }, cache_file: cache_filename }.merge(default_cache_options),
      )

      log = read_cache(cache_filename)
      expect(log.keys.length).to(eq(3))

      # should look like:
      # {
      #   "version": xxx,
      #   "internal": {
      #     "/": {
      #       "time": "2015-10-20 12:00:00 -0700",
      #       "found": false,
      #       "metadata": [...]
      #     }
      #   },
      #   "external": {
      #     "www.github.com": {
      #       "time": "2015-10-20 12:00:00 -0700",
      #       "status": 200,
      #       "message": "OK",
      #       "metadata": [...]
      #     }
      #   }
      # }

      expect(log["version"]).to(eq(2))

      external_urls = log["external"]
      external_url = external_urls["https://github.com/gjtorikian/html-proofer"]

      expect(external_url["status_code"]).to(eq(200))
      expect(external_url["metadata"].first["line"]).to(eq(7))

      internal_urls = log["internal"]
      internal_url = internal_urls["/somewhere.html"]

      expect(internal_url["metadata"].first["line"]).to(eq(11))
      expect(internal_url["metadata"].first["found"]).to(be(false))

      File.delete(cache_filepath) if File.exist?(cache_filepath)
    end

    it "internal cache is disabled w/o internal timeframe" do
      test_file = File.join(cache_fixture_dir, "internal_and_external_example.html")
      cache_filename = File.join(version, ".htmlproofer_test.json")
      cache_filepath = File.join(cache_fixture_dir, cache_filename)

      allow(described_class).to(receive(:write).once)

      expect_any_instance_of(HTMLProofer::Runner).not_to(receive(:load_internal_cache))

      run_proofer(
        test_file,
        :file,
        cache: { timeframe: { external: "30d" }, cache_file: cache_filename }.merge(default_cache_options),
      )

      cache = read_cache(cache_filename)
      expect(cache["external"].keys.length).to(eq(1))
      expect(cache["internal"].keys.length).to(eq(0))

      File.delete(cache_filepath) if File.exist?(cache_filepath)
    end

    it "external cache is disabled w/o external timeframe" do
      test_file = File.join(cache_fixture_dir, "internal_and_external_example.html")
      cache_filename = File.join(version, ".htmlproofer_test.json")
      cache_filepath = File.join(cache_fixture_dir, cache_filename)

      allow(described_class).to(receive(:write).once)

      expect_any_instance_of(HTMLProofer::Runner).not_to(receive(:load_external_cache))

      run_proofer(
        test_file,
        :file,
        cache: { timeframe: { internal: "30d" }, cache_file: cache_filename }.merge(default_cache_options),
      )

      cache = read_cache(cache_filename)
      expect(cache["internal"].keys.length).to(eq(1))
      expect(cache["external"].keys.length).to(eq(0))

      File.delete(cache_filepath) if File.exist?(cache_filepath)
    end

    it "internal/external cache is disabled w/o internal/external timeframe" do
      test_file = File.join(cache_fixture_dir, "internal_and_external_example.html")
      cache_filename = File.join(version, ".htmlproofer_test.json")
      cache_filepath = File.join(cache_fixture_dir, cache_filename)

      allow(described_class).to(receive(:write).once)

      expect_any_instance_of(HTMLProofer::Runner).not_to(receive(:load_internal_cache))
      expect_any_instance_of(HTMLProofer::Runner).not_to(receive(:load_external_cache))

      run_proofer(
        test_file,
        :file,
        cache: { timeframe: {}, cache_file: cache_filename }.merge(default_cache_options),
      )

      cache = read_cache(cache_filename)
      expect(cache["internal"].keys.length).to(eq(0))
      expect(cache["external"].keys.length).to(eq(0))

      File.delete(cache_filepath) if File.exist?(cache_filepath)
    end

    context "when checking external links and including dates" do
      let(:cache_filename) { File.join(version, ".within_date_external.json") }

      it "does not write file if timestamp is within date" do
        new_time = Time.local(2015, 10, 27, 12, 0, 0)
        Timecop.freeze(new_time) do
          expect_any_instance_of(described_class).to(receive(:write))

          # we expect no add since we are within the timeframe
          expect_any_instance_of(described_class).not_to(receive(:add_external))

          run_proofer(
            ["www.github.com"],
            :links,
            cache: { timeframe: { external: "30d" }, cache_file: cache_filename }.merge(default_cache_options),
          )
        end
      end

      it "does write file if timestamp is not within date" do
        new_time = Time.local(2021, 10, 27, 12, 0, 0)
        Timecop.freeze(new_time) do
          expect_any_instance_of(described_class).to(receive(:write))

          # we expect an add since we are mocking outside the timeframe
          expect_any_instance_of(described_class).to(receive(:add_external).with("www.github.com", [], 200, "OK", true))

          run_proofer(
            ["www.github.com"],
            :links,
            cache: { timeframe: { external: "4d" }, cache_file: cache_filename }.merge(default_cache_options),
          )
        end
      end
    end

    context "when checking external links and a new external url added" do
      let(:cache_filename) { File.join(version, ".new_external_url.json") }

      it "does write file if a new URL is added" do
        new_time = Time.local(2015, 10, 20, 12, 0, 0)
        Timecop.freeze(new_time) do
          expect_any_instance_of(described_class).to(receive(:write))
          # we expect one new link to be added, but github.com can stay...
          expect_any_instance_of(described_class).to(receive(:add_external).with("www.google.com", [], 200, "OK", true))

          # ...because it's within the 30d time frame
          run_proofer(
            ["www.github.com", "www.google.com"],
            :links,
            cache: { timeframe: { external: "30d" }, cache_file: cache_filename }.merge(default_cache_options),
          )
        end
      end

      it "handles slashed and unslashed URLs as the same" do
        new_time = Time.local(2015, 10, 20, 12, 0, 0)
        Timecop.freeze(new_time) do
          expect_any_instance_of(described_class).to(receive(:write))

          # we expect no new link to be added, because it's the same as the cache link (but with a `/`)
          expect_any_instance_of(described_class).not_to(receive(:add_external))

          run_proofer(
            ["www.github.com/"],
            :links,
            cache: { timeframe: { external: "30d" }, cache_file: cache_filename }.merge(default_cache_options),
          )
        end
      end

      it "handles multiple slashed and unslashed URLs during additions/deletions" do
        cache_filename = File.join(version, ".trailing_slashes.json")
        cache_filepath = File.join(cache_fixture_dir, cache_filename)
        test_file = File.join(FIXTURES_DIR, "cache", "trailing_slashes.html")

        new_time = Time.local(2022, 1, 6, 12, 0, 0)
        Timecop.freeze(new_time) do
          File.delete(cache_filepath) if File.exist?(cache_filepath)

          run_proofer(
            test_file,
            :file,
            cache: { timeframe: { external: "1d" }, cache_file: cache_filename }.merge(default_cache_options),
          )

          cache = read_cache(cache_filename)
          external_urls = cache["external"]
          expect(external_urls.keys.sort).to(eq([
            "https://github.com",
            "https://github.com/gjtorikian",
            "https://github.com/riccardoporreca",
            "https://rubygems.org",
          ]))

          # we expect no new links to be added, because it's the same as the cache link
          expect_any_instance_of(described_class).not_to(receive(:add_external))

          run_proofer(
            test_file,
            :file,
            cache: { timeframe: { external: "1d" }, cache_file: cache_filename }.merge(default_cache_options),
          )

          cache = read_cache(cache_filename)
          external_urls = cache["external"]
          expect(external_urls.keys.sort).to(eq([
            "https://github.com",
            "https://github.com/gjtorikian",
            "https://github.com/riccardoporreca",
            "https://rubygems.org",
          ]))

          File.delete(cache_filepath)
        end
      end

      it "understands encodings even if it is unnormalized coming in" do
        new_time = Time.local(2015, 10, 20, 12, 0, 0)
        Timecop.freeze(new_time) do
          expect_any_instance_of(described_class).to(receive(:write))

          # we expect no new link to be added, because it's the same as the cache link
          expect_any_instance_of(described_class).not_to(receive(:add_external))

          run_proofer(
            ["github.com/search/issues?q=is%3Aopen+is%3Aissue+fig"],
            :links,
            cache: { timeframe: { external: "30d" }, cache_file: cache_filename }.merge(default_cache_options),
          )
        end
      end

      it "saves unencoded as normalized in cache" do
        cache_filename = File.join(version, ".some_other_external_url.json")
        new_time = Time.local(2015, 10, 20, 12, 0, 0)
        Timecop.freeze(new_time) do
          expect_any_instance_of(described_class).to(receive(:write))
          expect_any_instance_of(described_class).to(receive(:add_external))

          allow_any_instance_of(described_class).to(receive(:cleaned_url).with("github.com/search?q=is%3Aclosed+is%3Aissue+words").and_return("github.com/search?q=is:closed+is:issue+words"))

          run_proofer(
            ["github.com/search?q=is%3Aclosed+is%3Aissue+words"],
            :links,
            cache: { timeframe: { external: "30d" }, cache_file: cache_filename }.merge(default_cache_options),
          )
        end
      end
    end

    context "when checking internal links and including dates" do
      let(:cache_filename) { File.join(version, ".within_date_internal.json") }
      let(:test_file) { File.join(FIXTURES_DIR, "links", "working_root_link_internal.html") }
      let(:new_time) { Time.local(2015, 10, 27, 12, 0, 0) }

      it "does not write file if timestamp is within date" do
        Timecop.freeze(new_time) do
          expect_any_instance_of(described_class).to(receive(:write))

          # we expect no add since we are within the timeframe
          expect_any_instance_of(described_class).not_to(receive(:add_internal))

          run_proofer(
            test_file,
            :file,
            disable_external: true,
            cache: { timeframe: { internal: "30d" }, cache_file: cache_filename }.merge(default_cache_options),
          )
        end
      end

      it "does write file if timestamp is not within date" do
        Timecop.freeze(new_time) do
          expect_any_instance_of(described_class).to(receive(:write))

          # we expect an add since we are mocking outside the timeframe
          expect_any_instance_of(described_class).to(receive(:add_internal).with(
            "/tel_link.html", { base_url: "", filename: "spec/html-proofer/fixtures/links/working_root_link_internal.html", found: false, line: 5, source: test_file }, true
          ))

          run_proofer(
            test_file,
            :file,
            disable_external: true,
            cache: { timeframe: { internal: "4d" }, cache_file: cache_filename }.merge(default_cache_options),
          )
        end
      end
    end

    context "when checking internal links and new internal url added" do
      let(:cache_filename) { File.join(version, ".new_internal_url.json") }
      let(:cache_filepath) { File.join(cache_fixture_dir, cache_filename) }
      # this is frozen to within 30 days of the log
      let(:new_time) { Time.local(2015, 10, 20, 12, 0, 0) }

      it "does write file if a new relative URL 200 is added" do
        Timecop.freeze(new_time) do
          root_link = File.join(FIXTURES_DIR, "links", "root_link", "root_link_with_another_link.html")

          expect_any_instance_of(described_class).to(receive(:add_internal).with(
            "/",
            { base_url: "", filename: root_link, found: false, line: 5, source: root_link },
            true,
          ).and_call_original)

          expect_any_instance_of(described_class).to(receive(:write).once)

          run_proofer(
            root_link,
            :file,
            disable_external: true,
            cache: { timeframe: { internal: "30d" }, cache_file: cache_filename }.merge(default_cache_options),
          )
        end
      end

      it "does write file if a new relative URL 404 is added" do
        Timecop.freeze(new_time) do
          expect_any_instance_of(described_class).to(receive(:write))
          root_link = File.join(FIXTURES_DIR, "links", "broken_internal_link.html")
          expect_any_instance_of(described_class).to(receive(:add_internal).once.with(
            "#noHash",
            { base_url: "", filename: root_link, found: false, line: 5, source: root_link },
            false,
          ))

          run_proofer(
            root_link,
            :file,
            disable_external: true,
            cache: { timeframe: { internal: "30d" }, cache_file: cache_filename }.merge(default_cache_options),
          )
        end
      end

      it "works if new broken internal file is added and cache is rechecked" do
        cache_filename = File.join(version, ".recheck_internal.json")
        cache_fullpath = File.join(FIXTURES_DIR, "cache", cache_filename)
        test_path = File.join(FIXTURES_DIR, "cache", "existing")
        subsite = File.join(FIXTURES_DIR, "cache", "existing", "broken")

        Timecop.freeze(new_time) do
          proofer = run_proofer(
            test_path,
            :directory,
            disable_external: true,
            cache: { timeframe: { internal: "1d" }, cache_file: cache_filename }.merge(default_cache_options),
          )

          expect(proofer.failed_checks).to(eq([]))
          cache = read_cache(cache_filename)
          internal_link = cache["internal"]["existing.html"]
          internal_link_metadata = internal_link["metadata"]
          index_metadata = internal_link_metadata.first
          expect(index_metadata["filename"]).to(eq("spec/html-proofer/fixtures/cache/existing/index.html"))
          expect(index_metadata["found"]).to(equal(true))

          FileUtils.mkdir_p(subsite)
          FileUtils.copy(File.join(test_path, "index.html"), File.join(subsite, "index.html"))

          proofer = run_proofer(
            test_path,
            :directory,
            disable_external: true,
            cache: { timeframe: { internal: "1d" }, cache_file: cache_filename }.merge(default_cache_options),
          )

          expect(proofer.failed_checks.count).to(eq(1))
          cache = read_cache(cache_filename)
          internal_link = cache["internal"]["existing.html"]
          internal_link_metadata = internal_link["metadata"]

          expect(internal_link_metadata.count).to(eq(2))

          first_cache_metadata = internal_link_metadata[0]
          expect(first_cache_metadata["filename"]).to(eq("spec/html-proofer/fixtures/cache/existing/index.html"))
          expect(first_cache_metadata["found"]).to(equal(true))

          second_cache_metadata = internal_link_metadata[1]
          expect(second_cache_metadata["filename"]).to(eq("spec/html-proofer/fixtures/cache/existing/broken/index.html"))
          expect(second_cache_metadata["found"]).to(equal(false))
        ensure # cleanup
          FileUtils.rm_rf(subsite) if File.directory?(subsite)
          FileUtils.rm_rf(cache_fullpath) if File.exist?(cache_fullpath)
        end
      end
    end

    context "when rechecking failures" do
      let(:new_time) { Time.local(2022, 1, 6, 12, 0, 0) }

      it "does recheck failures for newly valid links" do
        Timecop.freeze(new_time) do
          file = File.join(FIXTURES_DIR, "cache", "valid_link.html")

          # link from file is broken in this cache
          template = File.join(FIXTURES_DIR, "cache", version, ".broken_external_link.template")
          cache_filename = File.join(version, ".broken_external_link.json")
          cache_filepath = File.join(FIXTURES_DIR, "cache", cache_filename)
          FileUtils.cp(template, cache_filepath)

          cache = read_cache(cache_filename)
          external_link = cache["external"]["https://github.com/gjtorikian/html-proofer"]
          expect(external_link["found"]).to(equal(false))
          expect(external_link["status_code"]).to(equal(0))

          run_proofer(file, :file, cache: { timeframe: { external: "1d" }, cache_file: cache_filename }.merge(default_cache_options))

          cache = read_cache(cache_filename)
          external_link = cache["external"]["https://github.com/gjtorikian/html-proofer"]
          expect(external_link["found"]).to(equal(true))
          expect(external_link["status_code"]).to(equal(200))
          expect(external_link["message"]).equal?("OK")

          File.delete(cache_filepath)
        end
      end

      it "does recheck external failures, regardless of cache" do
        Timecop.freeze(new_time) do
          cache_filename = File.join(version, ".recheck_failure.json")

          expect_any_instance_of(described_class).to(receive(:write))

          # we expect the same link to be re-added, even though we are within the time frame,
          # because `foofoofoo.biz` was a failure
          expect_any_instance_of(described_class).to(receive(:add_external))

          run_proofer(
            ["http://www.foofoofoo.biz"],
            :links,
            cache: { timeframe: { external: "30d" }, cache_file: cache_filename }.merge(default_cache_options),
          )
        end
      end

      it "does recheck internal failures, regardless of cache" do
        cache_filename = File.join(version, ".broken_internal.json")
        test_path = File.join(FIXTURES_DIR, "cache", "example_site")
        test_file = File.join(test_path, "index.html")

        Timecop.freeze(new_time) do
          expect_any_instance_of(described_class).to(receive(:write))

          # we expect the same link to be re-added, even though we are within the time frame,
          # because `index.html` contains a failure
          expect_any_instance_of(described_class).to(receive(:add_internal).with(
            "/missing.html",
            { base_url: "", filename: test_file, found: false, line: 6, source: test_path },
            false,
          ))

          run_proofer(
            test_path,
            :directory,
            disable_external: true,
            cache: { timeframe: { internal: "30d" }, cache_file: cache_filename }.merge(default_cache_options),
          )
        end
      end

      it "does recheck failures, regardless of external-only cache" do
        Timecop.freeze(new_time) do
          cache_filename = File.join(version, ".recheck_external_failure.json")
          cache_filepath = File.join(cache_fixture_dir, cache_filename)

          file = File.join(FIXTURES_DIR, "cache", "external_example.html")

          File.delete(cache_filepath) if File.exist?(cache_filepath)

          run_proofer(file, :file, cache: { timeframe: { external: "1d" }, cache_file: cache_filename }.merge(default_cache_options))

          cache = read_cache(cache_filename)
          external_links = cache["external"]
          expect(external_links.keys.first).to(eq("https://github.com/gjtorikian/html-proofer"))

          run_proofer(file, :file, cache: { timeframe: { external: "1d" }, cache_file: cache_filename }.merge(default_cache_options))

          cache = read_cache(cache_filename)
          external_links = cache["external"]
          expect(external_links.keys.first).to(eq("https://github.com/gjtorikian/html-proofer"))
        end
      end

      it "does recheck failures, regardless of external and internal cache" do
        cache_filename = File.join(version, ".internal_and_external.json")
        cache_location = File.join(cache_fixture_dir, cache_filename)

        file = File.join(FIXTURES_DIR, "cache", "internal_and_external_example.html")
        Timecop.freeze(new_time) do
          File.delete(cache_location) if File.exist?(cache_location)

          run_proofer(file, :file, cache: { timeframe: { external: "1d", internal: "1d" }, cache_file: cache_filename }.merge(default_cache_options))

          cache = read_cache(cache_filename)
          external_links = cache["external"]
          expect(external_links.keys.first).to(eq("https://github.com/gjtorikian/html-proofer"))
          expect(external_links["https://github.com/gjtorikian/html-proofer"]["metadata"].count).to(eq(1))
          internal_links = cache["internal"]
          expect(internal_links.keys.first).to(eq("/somewhere.html"))
          expect(internal_links["/somewhere.html"]["metadata"].count).to(eq(1))

          run_proofer(file, :file, cache: { timeframe: { external: "1d", internal: "1d" }, cache_file: cache_filename }.merge(default_cache_options))

          cache = read_cache(cache_filename)
          external_links = cache["external"]
          expect(external_links.keys.first).to(eq("https://github.com/gjtorikian/html-proofer"))
          expect(external_links["https://github.com/gjtorikian/html-proofer"]["metadata"].count).to(eq(1))
          internal_links = cache["internal"]
          expect(internal_links.keys.first).to(eq("/somewhere.html"))
          expect(internal_links["/somewhere.html"]["metadata"].count).to(eq(1))
        end
      end
    end

    context "when removing links" do
      let(:new_time) { Time.local(2022, 1, 6, 12, 0, 0) }

      it "removes external links that no longer exist" do
        Timecop.freeze(new_time) do
          test_file = File.join(FIXTURES_DIR, "cache", "external_example.html")
          cache_filename = File.join(version, ".removed_link.json")
          cache_location = File.join(cache_fixture_dir, cache_filename)

          File.delete(cache_location) if File.exist?(cache_location)

          run_proofer(
            test_file,
            :file,
            cache: { timeframe: { external: "1d" }, cache_file: cache_filename }.merge(default_cache_options),
          )

          cache = read_cache(cache_filename)
          external_links = cache["external"]
          expect(external_links.keys.first).to(eq("https://github.com/gjtorikian/html-proofer"))

          run_proofer(
            File.join(FIXTURES_DIR, "cache", "some_link.html"),
            :file,
            cache: { timeframe: { external: "1d" }, cache_file: cache_filename }.merge(default_cache_options),
          )

          cache = read_cache(cache_filename)
          external_links = cache["external"]
          expect(external_links.keys.first).to(eq("https://github.com/gjtorikian"))
        end
      end
    end
  end
end
