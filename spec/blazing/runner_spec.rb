require 'spec_helper'
require 'blazing/runner'

#
# Note: More specs for Runner in the integration directory.
#

describe Blazing::Runner do

  before :each do
    @config = Blazing::Config.new
    @config.target :sometarget, 'somewhere', :default => true
  end

  describe '#exec' do

    it 'fails if the command does not exist' do
      lambda { Blazing::Runner.new(@config).exec('weird_command') }.should raise_error
    end

    it 'knows the init command' do
      runner = Blazing::Runner.new(@config)
      runner.should_receive(:init_command)
      runner.exec('init')
    end

    it 'knows the setup:local command' do
      runner = Blazing::Runner.new(@config)
      runner.should_receive(:setup_local_command)
      runner.exec('setup:local')
    end

    it 'knows the setup:remote command' do
      runner = Blazing::Runner.new(@config)
      runner.should_receive(:setup_remote_command)
      runner.exec('setup:remote')
    end

    it 'knows the deploy command' do
      runner = Blazing::Runner.new(@config)
      runner.should_receive(:deploy_command)
      runner.exec('deploy')
    end

  end

end
