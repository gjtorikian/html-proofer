# frozen_string_literal: true

class HTMLProofer::Attribute::Url < HTMLProofer::Attribute
  attr_reader :url

  def initialize(runner, link_attribute, base_url: nil)
    super

    if @raw_attribute.nil?
      @url = nil
    else
      @url = @raw_attribute.delete("\u200b").strip
      @url = Addressable::URI.join(base_url, @url).to_s unless blank?(base_url)

      @url = swap_urls

      # convert "//" links to "https://"
      @url.start_with?('//') ? @url = "https:#{@url}" : @url
    end
  end

  def to_s
    @url
  end

  def ignore?
    return true if (/^javascript:/).match?(@url)
    return true if ignores_pattern?(@runner.options[:ignore_urls])
  end

  def valid?
    !parts.nil? || raw_attribute.nil? # it's valid because it doesn't exist, which is okay in HTML5
  end

  def path?
    !parts.host.nil? && !parts.path.nil?
  end

  def parts
    @parts ||= Addressable::URI.parse @url
  rescue URI::Error, Addressable::URI::InvalidURIError
    @parts = nil
  end

  def path
    Addressable::URI.unencode parts.path unless parts.nil?
  end

  def hash
    parts&.fragment
  end

  def scheme
    parts&.scheme
  end

  # path is to an external server
  def remote?
    %w[http https].include?(scheme)
  end

  def http?
    scheme == 'http'
  end

  def https?
    scheme == 'https'
  end

  def non_http_remote?
    !scheme.nil? && !remote?
  end

  # checks if a file exists relative to the current pwd
  def exists?
    return true if base64_link?

    return @runner.checked_paths[absolute_path] if @runner.checked_paths.key?(absolute_path)

    @runner.checked_paths[absolute_path] = File.exist?(absolute_path)
  end

  def base64_link?
    /^data:image/.match?(@raw_attribute)
  end

  def absolute_path
    path = file_path || @runner.current_path

    File.expand_path(path, Dir.pwd)
  end

  def file_path
    return if path.nil? || path.empty?

    path_dot_ext = ''

    path_dot_ext = path + @runner.options[:extension] if @runner.options[:assume_extension]

    base = if absolute_path?(path) # path relative to root
             # either overwrite with root_dir; or, if source is directory, use that; or, just get the current file's dirname
             @runner.options[:root_dir] || (File.directory?(@runner.current_source) ? @runner.current_source : File.dirname(@runner.current_source))
           # relative links, path is a file
           elsif File.exist?(File.expand_path(path, @runner.current_source)) || File.exist?(File.expand_path(path_dot_ext, @runner.current_source))
             File.dirname(@runner.current_path)
           # relative links in nested dir, path is a file
           elsif File.exist?(File.join(File.dirname(@runner.current_path), path)) || File.exist?(File.join(File.dirname(@runner.current_path), path_dot_ext)) # rubocop:disable Lint/DuplicateBranch
             File.dirname(@runner.current_path)
           # relative link, path is a directory
           else
             @runner.current_path
           end

    file = File.join(base, path)

    if @runner.options[:assume_extension] && File.file?("#{file}#{@runner.options[:extension]}")
      file = "#{file}#{@runner.options[:extension]}"
    elsif File.directory?(file) && !unslashed_directory?(file) # implicit index support
      file = File.join file, @runner.options[:directory_index_file]
    end

    file
  end

  def unslashed_directory?(file)
    File.directory?(file) && !file.end_with?(File::SEPARATOR)
  end

  def absolute_path?(path)
    path.start_with?('/')
  end

  # path is external to the file
  def external?
    !internal?
  end

  def internal?
    relative_link? || internal_absolute_link? || hash_link?
  end

  def internal_absolute_link?
    url.start_with?('/')
  end

  def relative_link?
    return false if remote?

    hash_link? || param_link? || url.start_with?('.') || url =~ /^\S/
  end

  def link_points_to_same_page?
    hash_link || param_link
  end

  def hash_link?
    url.start_with?('#')
  end

  def param_link?
    url.start_with?('?')
  end

  private def swap_urls
    return @url if blank?(replacements = @runner.options[:swap_urls])

    replacements.each do |link, replace|
      @url = @url.gsub(link, replace)
    end

    @url
  end

  def ignores_pattern?(links_to_ignore)
    return false unless links_to_ignore.is_a?(Array)

    links_to_ignore.each do |link_to_ignore|
      case link_to_ignore
      when String
        return true if link_to_ignore == @raw_attribute
      when Regexp
        return true if link_to_ignore&.match?(@raw_attribute)
      end
    end

    false
  end
  #    private def follow_location?
  #   @check.options[:typhoeus] && @check.options[:typhoeus][:followlocation]
  # end
end
