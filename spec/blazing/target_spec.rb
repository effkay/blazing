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
      @config = Blazing::Config.new
      @config.targets << @target
      Blazing::Config.stub!(:parse).and_return(@config)
    end

    it 'clones the repository on the target location' do
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
  end

  describe '.deploy' do
    before :each do
      @target = Blazing::Target.new('somename', @options)
      @config = Blazing::Config.new
      @config.targets << @target
      Blazing::Config.stub!(:parse).and_return(@config)
      @runner = double('runner', :run => nil)
      Blazing::Runner.stub!(:new).and_return(@runner)
    end

    it 'uses git push to deploy to the target' do
      @runner.should_receive(:run).with(/git push somename/)
      Blazing::Target.deploy('somename')
    end

    it 'pushes the correct branch when one is configured' do
      @target.branch = 'somebranch'
      @runner.should_receive(:run).with(/git push somename somebranch:somebranch/)
      Blazing::Target.deploy('somename')
    end
  end

  describe 'config' do
    it 'delegates to Blazing::Config.load' do
      Blazing::Config.should_receive(:parse)
      Blazing::Target.config
    end
  end
end
