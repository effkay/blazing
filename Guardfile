guard :rspec, version: 2, cli: '--colour --fail-fast' do
  # Generated: by guard-rspec
  watch(%r{^spec/.+_spec\.rb})
  watch(%r{^lib/(.+)\.rb})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { 'spec' }

  # Not Generated
  watch('spec/spec_helper.rb')                        { %w(spec/spec_helper spec) }
  watch(%r{^spec/.+_spec\.rb})
  watch(%r{^lib/(.+)\.rb})     { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/blazing/(.+)\.rb})     { |m| "spec/blazing/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { 'spec' }
  watch(%r{^lib/blazing/templates/(.+)}) { 'spec' }
  watch('lib/blazing/cli.rb') { 'spec/blazing/integration/*' }
  watch('lib/blazing/commands.rb') { 'spec/blazing/integration/*' }
end
