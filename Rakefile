require 'bundler'
require 'rake/clean'
require 'cucumber'
require 'cucumber/rake/task'
require 'rdoc/task'
require 'rspec/core/rake_task'

include Rake::DSL

Bundler::GemHelper.install_tasks

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  # t.rspec_opts = %w(--colour --fail-fast --format nested)
  t.rspec_opts = %w(--colour  --format nested)
  t.ruby_opts  = %w(-w)
end

CUKE_RESULTS = 'results.html'
CLEAN << CUKE_RESULTS
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format html -o #{CUKE_RESULTS} --format progress -x"
  t.fork = false
end

Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc","lib/**/*.rb","bin/**/*")
end

task :default => [:spec,:features]
