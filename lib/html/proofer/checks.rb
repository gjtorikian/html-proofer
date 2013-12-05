module HTML
  class Proofer
    class Checks
      require File.dirname(__FILE__) + '/check'
      require File.dirname(__FILE__) + '/checks/images'
      require File.dirname(__FILE__) + '/checks/links'
    end
  end
end
