# frozen_string_literal: true

require "bundler/setup"
require "vcr"
require "timecop"
require "html_proofer"
require "open3"
require "socket"

FIXTURES_DIR = "spec/html-proofer/fixtures"

# Serves one static file over HTTP on an ephemeral port.
#
# The PDF hash check re-reads the response with OpenURI rather than Typhoeus
# (see `check_hash_in_2xx_response`), so VCR — which hooks Typhoeus only —
# cannot record it. Pointing that read at a local server keeps the suite off
# the network instead of depending on a third-party host's rate limits.
#
# Hand-rolled on TCPServer because webrick left stdlib in Ruby 3.0, and serving
# a single file does not justify a new development dependency.
class StaticFileServer
  class << self
    # Boots a server for the duration of the block, then always tears it down.
    def serving(path, content_type:)
      server = new(path, content_type: content_type)
      begin
        yield server
      ensure
        server.stop
      end
    end
  end

  def initialize(path, content_type:)
    @body = File.binread(path)
    @content_type = content_type
    @socket = TCPServer.new("127.0.0.1", 0)
    @running = true
    @workers = []
    # a server has to accept off the main thread, or the spec cannot make requests
    @listener = Thread.new { accept_loop } # rubocop:disable ThreadSafety/NewThread
  end

  def origin
    "http://127.0.0.1:#{@socket.addr[1]}"
  end

  def stop
    @running = false
    @socket.close unless @socket.closed?
    @listener.join(2)
    @workers.each { |worker| worker.join(1) }
  end

  private def accept_loop
    while @running
      begin
        client = @socket.accept
      rescue IOError, Errno::EBADF, Errno::EINVAL
        break # #stop closed the socket out from under us
      end
      # the PDF check issues two requests; serving each off-thread keeps a slow
      # reader from blocking the next one
      @workers << Thread.new { respond(client) } # rubocop:disable ThreadSafety/NewThread
    end
  end

  private def respond(client)
    request_line = client.gets
    return if request_line.nil?

    # Drain the headers before replying; a client still writing its request
    # sees a connection reset otherwise.
    while (line = client.gets)
      break if line == "\r\n" || line == "\n"
    end

    client.write("HTTP/1.1 200 OK\r\n")
    client.write("Content-Type: #{@content_type}\r\n")
    client.write("Content-Length: #{@body.bytesize}\r\n")
    client.write("Connection: close\r\n\r\n")
    client.write(@body) unless request_line.start_with?("HEAD ")
  rescue Errno::EPIPE, Errno::ECONNRESET
    nil # client hung up early; the spec will report the real problem
  ensure
    client.close unless client.nil? || client.closed?
  end
end

RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate

  # Run in a random order
  config.order = :random
end

def capture_stderr(*)
  original_stderr = $stderr
  original_stdout = $stdout
  $stderr = fake_err = StringIO.new
  $stdout = StringIO.new unless ENV["DEBUG"]
  begin
    yield
  rescue SystemExit
  ensure
    $stderr = original_stderr
    $stdout = original_stdout unless ENV["DEBUG"]
  end
  fake_err.string
end

def make_proofer(item, type, opts)
  opts[:log_level] ||= :error
  case type
  when :file
    HTMLProofer.check_file(item, opts)
  when :directory
    HTMLProofer.check_directory(item, opts)
  when :directories
    HTMLProofer.check_directories(item, opts)
  when :links
    HTMLProofer.check_links(item, opts)
  end
end

def run_proofer(item, type, opts = {})
  proofer = make_proofer(item, type, opts)
  cassette_name = make_cassette_name(item, opts)
  VCR.use_cassette(cassette_name, record: :new_episodes) do
    capture_stderr { proofer.run }
    proofer
  end
end

# Runs without a cassette, for specs served by StaticFileServer. Recording a
# local server would bake an ephemeral port into a cassette, and VCR is
# configured to let localhost through regardless.
def run_proofer_live(item, type, opts = {})
  proofer = make_proofer(item, type, opts)
  capture_stderr { proofer.run }
  proofer
end

def capture_proofer_http(item, type, opts = {})
  proofer = make_proofer(item, type, opts)
  cassette_name = make_cassette_name(item, opts)
  VCR.use_cassette(cassette_name, record: :new_episodes) do
    capture_stderr { proofer.run }
    VCR.current_cassette.serializable_hash["http_interactions"].last
  end
end

def make_bin(args)
  ap("#{RbConfig.ruby} exe/htmlproofer #{args}") if debug? # rubocop:disable RSpec/Output
  stdout, stderr = Open3.capture3("#{RbConfig.ruby} exe/htmlproofer #{args}")
  # Filter out Ruby experimental warnings (e.g., IO::Buffer in Ruby 4.0)
  stderr = stderr.lines.reject { |line| line.include?("warning:") && line.include?("experimental") }.join
  "#{stdout}\n#{stderr}".encode("UTF-8", invalid: :replace, undef: :replace)
end

def make_cassette_name(file, opts)
  filename = if file.is_a?(Array)
    file.join("_")
  else
    file.split("/")[-2..].join("/")
  end
  (filename += opts.inspect) unless opts.empty?
  filename
end

def debug?
  ENV.fetch("DEBUG", false)
end

def ci?
  ENV.fetch("CI", false)
end

VCR.configure do |config|
  config.cassette_library_dir = File.join(FIXTURES_DIR, "vcr_cassettes")
  config.hook_into(:typhoeus)
  # Requests to StaticFileServer are already local and deterministic; recording
  # them would only pin an ephemeral port into a cassette.
  config.ignore_localhost = true
end
