require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => [:spec, :readme]

task :readme do
  require 'html/proofer'
  require 'redcarpet'

  redcarpet = Redcarpet::Markdown.new Redcarpet::Render::HTML.new({}), {}

  html = redcarpet.render File.open("README.md").read
  File.open "_README.html", File::CREAT|File::WRONLY do |file|
    file.puts html
  end

  # test your out dir!
  HTML::Proofer.new("_README.html").run
end
