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

  opts = { :url_ignore => [/badge.fury.io/] }
  HTMLProofer.check_directory('./out', opts).run
end

namespace :site do
  GH_PAGES_DIR = "_gh-pages"
  directory GH_PAGES_DIR
  file GH_PAGES_DIR do |f|
    sh "git clone git@github.com:gjtorikian/html-proofer #{f.name}"
  end

  desc "Commit the local site to the gh-pages branch and publish to GitHub Pages"
  task :publish => [GH_PAGES_DIR] do
    Dir.chdir GH_PAGES_DIR do
      sh "git checkout gh-pages"
      sh "git pull origin gh-pages"
    end

    puts "Cleaning gh-pages directory..."
    rm_rf FileList[File.join(GH_PAGES_DIR, "**", "*")]

    puts "Copying site to gh-pages branch..."
    cp_r FileList[File.join("site", "*"), ".gitignore"], GH_PAGES_DIR

    puts "Committing and pushing to GitHub Pages..."
    sha = `git log`.match(/[a-z0-9]{40}/)[0]
    Dir.chdir GH_PAGES_DIR do
      sh "git add ."
      sh "git commit --allow-empty -m 'Updating to #{sha}.'"
      sh "git push origin gh-pages"
    end
    puts 'Done.'
  end
end
