require 'bundler/setup'
require 'vcr'
require 'timecop'
require_relative '../lib/html/proofer'

FIXTURES_DIR = 'spec/html/proofer/fixtures'

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
  $stdout = fake_out = StringIO.new unless ENV['NOISE']
  begin
    yield
  rescue RuntimeError
  ensure
    $stderr = original_stderr unless ENV['NOISE']
    $stdout = original_stdout
  end
  fake_err.string
end

def make_proofer(file, opts)
  opts[:verbosity] ||= :fatal
  HTML::Proofer.new(file, opts)
end

def run_proofer(file, opts = {})
  cassette_name = make_cassette_name(file, opts)
  proofer = make_proofer(file, opts)
  VCR.use_cassette(cassette_name, :record => :new_episodes) do
    capture_stderr { proofer.run }
    proofer
  end
end

def send_proofer_output(file, opts = {})
  cassette_name = make_cassette_name(file, opts)
  proofer = make_proofer(file, opts)
  VCR.use_cassette(cassette_name, :record => :new_episodes) do
    capture_stderr { proofer.run }
  end
end

def make_bin(cmd, path=nil)
  `bin/htmlproof #{cmd} #{path}`
end

def delete_cache
  File.delete(HTML::Proofer::Cache::FILENAME) if File.exist?(HTML::Proofer::Cache::FILENAME)
end

def read_cache
  JSON.parse File.read(HTML::Proofer::Cache::FILENAME)
end

def make_cassette_name(file, opts)
  filename = if file.is_a? Array
               file.join('_')
             else
               file.split('/')[-2..-1].join('/')
             end
  (filename += opts.inspect) unless opts.empty?
  filename
end

VCR.configure do |config|
  config.cassette_library_dir = "#{FIXTURES_DIR}/vcr_cassettes"
  config.hook_into :typhoeus
end
