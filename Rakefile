require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => [:spec, :proof_readme]

task :proof_readme do
  require 'html/proofer'
  require 'redcarpet'

  redcarpet = Redcarpet::Markdown.new Redcarpet::Render::HTML.new({}), {}
  html = redcarpet.render File.open("README.md").read

  mkdir_p "out"
  File.open "out/README.html", File::CREAT|File::WRONLY do |file|
    file.puts html
  end

  HTML::Proofer.new("./out").run
end
