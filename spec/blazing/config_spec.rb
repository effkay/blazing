require 'spec_helper'
require 'blazing/config'

describe Blazing::Config do

  before :each do
    @config = Blazing::Config.new
  end

  describe '#target' do
    it 'adds a target to the config object' do
      @config.target(:test_target, :deploy_to => 'smoeone@somewhere:/asdasdasd')
      @config.targets.size.should == 1
    end
  end

  describe '#use' do
    it 'adds a recipe to the config object' do
      @config.use(:rvm)
      @config.recipes.size.should == 1
    end
  end

  describe '#find_target' do
    context 'when a target name is given' do
      it 'returns the target with the given name' do
        @config.target(:test_target, :deploy_to => 'smoeone@somewhere:/asdasdasd')
        @config.find_target(:test_target).name.should == 'test_target'
      end
    end

    context 'when no target name given' do
      it 'returns the target defined in config if there is only one' do
        @config.target(:test_target, :deploy_to => 'smoeone@somewhere:/asdasdasd')
        @config.find_target.name.should == 'test_target'
      end

      it 'returns the default target if there is one' do
        @config.target(:test_target, :deploy_to => 'smoeone@somewhere:/asdasdasd')
        @config.target(:default_target, :default => true, :deploy_to => 'smoeone@somewhere:/asdasdasd')
        @config.find_target.name.should == 'default_target'
      end

      it 'raises an error if no target could be determined' do
        lambda { @config.find_target }.should raise_error
      end
    end
  end

  describe '.dsl_setter' do
    before :each do
      @config.class.class_eval do
        dsl_setter :foo
      end
    end

    it 'creates a dsl method to set the attribute in the config class' do
      @config.foo 'something'
      @config.instance_variable_get('@foo').should == 'something'
    end

    it 'creates a dsl method that allows to read the attribute in the config class' do
      @config.foo 'something'
      @config.foo.should == 'something'
    end
  end

  describe '.load' do
    it 'reads and parses the config file and returns a config object' do
      Blazing.send(:remove_const, 'CONFIGURATION_FILE')
      Blazing::CONFIGURATION_FILE = 'spec/support/config.rb'
      Blazing::Config.parse.should be_a Blazing::Config
    end
  end

  describe '.read' do
    it 'parses the config and returns a config object' do
      @config.class.read {}.should be_a Blazing::Config
    end
  end

end
