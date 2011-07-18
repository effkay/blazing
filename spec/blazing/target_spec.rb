require 'spec_helper'
require 'blazing/target'

describe Blazing::Target do

  before :each do
    @logger = double('logger')
    @runner = double('runner', :run => nil)
    @hook = double('hook', :new => double('template', :generate => nil))
    @options = { :deploy_to => 'someone@somehost:/some/path', :_hook => @hook, :_runner => @runner, :_logger => @logger }
    Blazing::Config.stub!(:parse).and_return(Blazing::Config.new)
  end

  describe '#initialize' do
    context 'with deploy_to option' do
      it 'sets the configuration options accordingly and creates an accessor' do
        @target = Blazing::Target.new('somename', @options)
        @target.deploy_to.should == @options[:deploy_to]
      end

      it 'extracts the hostname from the deploy_to option' do
        @target = Blazing::Target.new('somename', @options)
        @target.host.should == 'somehost'
      end

      it 'extracts the username from the deploy_to option' do
        @target = Blazing::Target.new('somename', @options)
        @target.user.should == 'someone'
      end

      it 'extracts the path from the deploy_to option' do
        @target = Blazing::Target.new('somename', @options)
        @target.path.should == '/some/path'
      end

      it 'overrides the hostname that was set explicitly' do
        @target = Blazing::Target.new('somename', @options.merge({ :host => 'anotherhost' }))
        @target.host.should == 'somehost'
      end

      it 'overrides the username that was set explicitly' do
        @target = Blazing::Target.new('somename', @options.merge({ :user => 'anotheruser' }))
        @target.user.should == 'someone'
      end

      it 'overrides the path that was set explicitly' do
        @target = Blazing::Target.new('somename', @options.merge({ :path => 'anotherpath' }))
        @target.path.should == '/some/path'
      end
    end

    context 'with missing options' do
      it 'raises an error if the path option is missing' do
        @options = { :host => 'somehost', :user => 'someuser' }
        lambda { Blazing::Target.new('somename', @options) }.should raise_error
      end

      it 'raises an error if the host option is missing' do
        @options = { :user => 'someuser', :path => 'somepath' }
        lambda { Blazing::Target.new('somename', @options) }.should raise_error
      end

      it 'raises an error if the user option is missing' do
        @options = { :host => 'somehost', :path => 'somepath' }
        lambda { Blazing::Target.new('somename', @options) }.should raise_error
      end
    end
  end

  describe '.setup' do
    before :each do
      @target = Blazing::Target.new('somename', @options)
    end

    it 'clones the repository on the target location' do
      Blazing::Config.stub!(:parse).and_return(Blazing::Config.new)
      @target.should_receive(:clone_repository)
      Blazing::Target.setup('somename')
    end

    it 'adds the target as a git remote' do
      @target.should_receive(:add_target_as_remote)
      Blazing::Target.setup('somename')
    end

    it 'sets up the post-receive hook' do
      @target.should_receive(:setup_post_receive_hook)
      Blazing::Target.setup('somename')
    end

    it 'checks out the correct branch if a branch is specified' do
      @target.branch = 'test'
      @target.should_receive(:checkout_correct_branch)
      Blazing::Target.setup('somename')
    end
  end

  describe '.deploy' do
    it 'uses git push to deploy to the target' do
      target = Blazing::Target.new('somename', @options)
      @runner.should_receive(:run).with(/git push somename/)
      target.deploy
    end

    it 'pushes the correct branch when one is configured' do
      target = Blazing::Target.new('somename', @options)
      target.branch = 'somebranch'
      @runner.should_receive(:run).with(/git push somename somebranch:somebranch/)
      target.deploy
    end
  end

  describe '#config' do
    it 'delegates to Blazing::Config.load' do
      blazing_config = double
      target = Blazing::Target.new('somename', @options)
      target.instance_variable_set("@config", blazing_config)
      blazing_config.should_receive(:parse)
      target.config
    end
  end
end
