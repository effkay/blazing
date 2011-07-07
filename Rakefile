require 'bundler'
Bundler::GemHelper.install_tasks
Bundler.setup

require 'rspec/core/rake_task'

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  # t.rspec_opts = %w(--colour --fail-fast --format nested)
  t.rspec_opts = %w(--colour  --format nested)
  t.ruby_opts  = %w(-w)
end

task :default => :spec
