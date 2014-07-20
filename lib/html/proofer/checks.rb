module HTML
  class Proofer
    class Checks
      [
        "/check",
        "/checks/images",
        "/checks/links",
        "/checks/scripts",
        "/checks/favicon"
      ].each { |r| require File.dirname(__FILE__) + r }
    end
  end
end
