require 'bundler'
require 'rake/clean'
require 'rdoc/task'
require 'rspec/core/rake_task'

include Rake::DSL

Bundler::GemHelper.install_tasks

desc 'Run specs'
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = %w(--colour --fail-fast)
  t.ruby_opts  = %w(-w)
end

Rake::RDocTask.new do |rd|
  rd.main = 'README.rdoc'
  rd.rdoc_files.include('README.rdoc', 'lib/**/*.rb', 'bin/**/*')
end

task default: [:spec]
