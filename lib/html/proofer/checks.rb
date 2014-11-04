module HTML
  class Proofer
    class Checks
      [
        "issue",
        "check",
        "checks/images",
        "checks/links",
        "checks/scripts",
        "checks/favicon",
        "checks/html"
      ].each { |r| require File.join(File.dirname(__FILE__), r) }
    end
  end
end
