def require_all(path)
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  Dir[glob].each do |f|
    require f
  end
end

require_all 'html-proofer'
require_all 'html-proofer/check'

require 'parallel'
require 'fileutils'

begin
  require 'awesome_print'
rescue LoadError; end

module HTMLProofer
  attr_reader :options, :external_urls

  def check_file(file, options)
    HTMLProofer::Runner.new(file, options)
  end
  module_function :check_file
end
