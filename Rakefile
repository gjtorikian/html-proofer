# frozen_string_literal: true

require "bundler"
Bundler::GemHelper.install_tasks

require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new(:rubocop)

task default: [:spec, :proof_readme]

desc "Test the project"
task :test do
  Rake::Task["spec"].invoke
end

desc "Run proofer on the README"
task :proof_readme do
  require "html-proofer"
  require "redcarpet"

  renderer = Redcarpet::Render::HTML.new(\
    with_toc_data: true
  )
  redcarpet = Redcarpet::Markdown.new(renderer)
  html = redcarpet.render(File.read("README.md"))

  mkdir_p "out"
  File.write("out/README.html", html)

  opts = {}
  HTMLProofer.check_directory("./out", opts).run
end
