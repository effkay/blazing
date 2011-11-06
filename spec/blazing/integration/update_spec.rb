# require 'spec_helper'
# require 'blazing/config'
# require 'blazing/runner'
# require 'grit'

# describe 'blazing update' do

#   before :each do
#     setup_sandbox
#     @production_url = 'user@host:/some/where'
#     @staging_url = 'user@host:/some/where/else'

#     @config = Blazing::Config.new
#     @config.target :production, @production_url
#     @config.target :staging, @staging_url, :default => true
#     @runner = Blazing::Runner
#   end

#   after :each do
#     teardown_sandbox
#   end

#   it 'generates the hook' do
#     @shell_double = double('shell')
#     @target = @config.default_target
#     @target.instance_variable_set('@shell', @shell_double)
#     @shell_double.stub(:run)
#     @runner.update
#     File.exists?(Blazing::TMP_HOOK).should be true
#   end

#   it 'copies the hook to the targets repository and makes it exectuable' do
#     @shell_double = double('shell')#Blazing::Shell.new
#     @target = @config.default_target
#     @target.instance_variable_set('@shell', @shell_double)

#     @shell_double.should_receive(:run).once.with("scp /tmp/post-receive user@host:/some/where/else/.git/hooks/post-receive")
#     @shell_double.should_receive(:run).once.with('ssh user@host chmod +x /some/where/else/.git/hooks/post-receive')
#     @runner.update
#   end

#   it 'adds a git remote for each target' do
#     @shell_double = double('shell', :run => true)
#     @target = @config.default_target
#     @target.instance_variable_set('@shell', @shell_double)
#     @runner.update
#     Grit::Repo.new(Dir.pwd).config['remote.production.url'].should == @production_url
#   end

# end
