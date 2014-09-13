require "spec_helper"

describe "Favicons test" do
  it "ignores for absent favicon by default" do
    absent = "#{FIXTURES_DIR}/favicon/favicon_absent.html"
    make_proofer(absent).failed_tests.should == []
  end

  it "fails for absent favicon" do
    absent = "#{FIXTURES_DIR}/favicon/favicon_absent.html"
    proofer = make_proofer(absent, {:favicon => true})
    proofer.failed_tests.first.should match /no favicon specified/
  end

  it "fails for absent favicon but present apple touch icon" do
    absent = "#{FIXTURES_DIR}/favicon/favicon_absent_apple.html"
    proofer = make_proofer(absent, {:favicon => true})
    proofer.failed_tests.last.should match /no favicon specified/
  end

  it "fails for broken favicon" do
    broken = "#{FIXTURES_DIR}/favicon/favicon_broken.html"
    proofer = make_proofer(broken, {:favicon => true})

    proofer.failed_tests.first.should match /internally linking to asdadaskdalsdk.png/
  end

  it "passes for present favicon" do
    present = "#{FIXTURES_DIR}/favicon/favicon_present.html"
    proofer = make_proofer(present, {:favicon => true})
    proofer.failed_tests.should == []
  end

  it "passes for present favicon with shortcut notation" do
    present = "#{FIXTURES_DIR}/favicon/favicon_present_shortcut.html"
    proofer =  make_proofer(present, {:favicon => true})
    proofer.failed_tests.should == []
  end

  it "fails for broken favicon with data-proofer-ignore" do
    broken_but_ignored = "#{FIXTURES_DIR}/favicon/favicon_broken_but_ignored.html"
    proofer = make_proofer(broken_but_ignored, {:favicon => true})
    proofer.failed_tests.first.should match /no favicon specified/
  end

end
