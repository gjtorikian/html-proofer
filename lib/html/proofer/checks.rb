module HTML
  class Proofer
    class Checks
      require File.dirname(__FILE__) + '/check'
      require File.dirname(__FILE__) + '/checks/images'
      require File.dirname(__FILE__) + '/checks/links'
      require File.dirname(__FILE__) + '/checks/scripts'
      require File.dirname(__FILE__) + '/checks/favicon'
    end
  end
end
