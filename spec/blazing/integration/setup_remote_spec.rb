require 'spec_helper'
require 'blazing/config'
require 'blazing/runner'
require 'grit'

describe 'blazing setup' do

  before :each do
    setup_sandbox
    @production_url = 'user@host:/some/where'
    @staging_url = 'user@host:/some/where/else'

    @config = Blazing::Config.new
    @config.target :production, @production_url
    @config.target :staging, @staging_url, :default => true
    @runner = Blazing::Runner.new(@config)
  end

  after :each do
    teardown_sandbox
  end

  it 'clones the repository, configures it and updates the target' do
    @shell = Blazing::Shell.new
    @target = @config.default_target
    @target.instance_variable_set('@shell', @shell)
    @shell.should_receive(:run).with("ssh user@host 'mkdir /some/where/else; cd /some/where/else && git init && cd /some/where/else && git config receive.denyCurrentBranch ignore'")
    @target.should_receive(:apply_hook)
    @runner.exec('setup')
  end

end
