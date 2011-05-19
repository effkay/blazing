require 'spec_helper'
require 'blazing/target'

describe Blazing::Target do

  before :each do
    @logger = double
    @options = { :deploy_to => 'someone@somehost:/some/path', :_logger => @logger }
  end

  context 'initializer' do

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
        @logger = double
        @options = { :host => 'somehost', :user => 'someuser', :_logger => @logger }
        lambda { Blazing::Target.new('somename', @options) }.should raise_error
      end

      it 'raises an error if the host option is missing' do
        @logger = double
        @options = { :user => 'someuser', :path => 'somepath', :_logger => @logger }
        lambda { Blazing::Target.new('somename', @options) }.should raise_error
      end

      it 'raises an error if the user option is missing' do
        @logger = double
        @options = { :host => 'somehost', :path => 'somepath', :_logger => @logger }
        lambda { Blazing::Target.new('somename', @options) }.should raise_error
      end
    end
  end

  it 'config delegates to Blazing::Config.load' do
    blazing_config = double
    target = Blazing::Target.new('somename', @options)
    target.instance_variable_set("@_config", blazing_config)
    blazing_config.should_receive(:load)
    target.config
  end
end
