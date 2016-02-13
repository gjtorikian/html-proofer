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

  def check_file(file, options = {})
    fail ArgumentError unless file.is_a?(String)
    options[:type] = :file
    HTMLProofer::Runner.new(file, options)
  end
  module_function :check_file

  def check_directories(directories, options = {})
    fail ArgumentError unless directories.is_a?(Array)
    options[:type] = :directory
    HTMLProofer::Runner.new(directories, options)
  end
  module_function :check_directories

  def check_links(links, options = {})
    fail ArgumentError unless links.is_a?(Array)
    options[:type] = :links
    HTMLProofer::Runner.new(links, options)
  end
  module_function :check_links
end
