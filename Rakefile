require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => [:spec, :readme]

task :readme do
  require 'html/proofer'
  require 'html/pipeline'

  # make an out dir
  mkdir_p "out"

  pipeline = HTML::Pipeline.new [
    HTML::Pipeline::MarkdownFilter,
    HTML::Pipeline::TableOfContentsFilter
  ], :gfm => true

  # generate HTML from Markdown
  contents = File.read("README.md")
  result = pipeline.call(contents)

  File.open("out/README.html", "w") { |file| file.write(result[:output].to_s) }

  # test your out dir!
  HTML::Proofer.new("./out/README.html").run
end
