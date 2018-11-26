def require_all(path)
  dir = File.join(File.dirname(__FILE__), path)
  Dir[File.join(dir, '*.rb')].each do |f|
    require f
  end
end

require_relative 'html-proofer/utils'
require_all 'html-proofer'
require_all 'html-proofer/check'

require 'parallel'
require 'fileutils'

begin
  require 'awesome_print'
  require 'pry-byebug'
rescue LoadError; end
module HTMLProofer
  def parse_json_option(option_name, config)
    raise ArgumentError.new('Must provide an option name in string format.') unless option_name.is_a?(String)
    raise ArgumentError.new('Must provide an option name in string format.') unless !option_name.strip.empty?

    if config.nil? then {}
    else
      raise ArgumentError.new('Must provide a JSON configuration in string format.') unless config.is_a?(String)

    if config.strip.empty? then {}
    else
      begin
        JSON.parse(config)
      rescue
        raise ArgumentError.new("Option '" + option_name + "' did not contain valid JSON.")
      end
    end
    end
  end
  module_function :parse_json_option

  def check_file(file, options = {})
    raise ArgumentError unless file.is_a?(String)
    raise ArgumentError, "#{file} does not exist" unless File.exist?(file)
    options[:type] = :file
    HTMLProofer::Runner.new(file, options)
  end
  module_function :check_file

  def check_directory(directory, options = {})
    raise ArgumentError unless directory.is_a?(String)
    raise ArgumentError, "#{directory} does not exist" unless Dir.exist?(directory)
    options[:type] = :directory
    HTMLProofer::Runner.new([directory], options)
  end
  module_function :check_directory

  def check_directories(directories, options = {})
    raise ArgumentError unless directories.is_a?(Array)
    options[:type] = :directory
    directories.each do |directory|
      raise ArgumentError, "#{directory} does not exist" unless Dir.exist?(directory)
    end
    HTMLProofer::Runner.new(directories, options)
  end
  module_function :check_directories

  def check_links(links, options = {})
    raise ArgumentError unless links.is_a?(Array)
    options[:type] = :links
    HTMLProofer::Runner.new(links, options)
  end
  module_function :check_links
end
