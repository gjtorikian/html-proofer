require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => [:spec, :proof_readme]

task :proof_readme do
  require 'html-proofer'
  require 'redcarpet'

  redcarpet = Redcarpet::Markdown.new Redcarpet::Render::HTML.new({}), {}
  html = redcarpet.render File.read('README.md')

  mkdir_p 'out'
  File.write('out/README.html', html)

  HTMLProofer.new('./out').run
end
