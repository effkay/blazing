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
    it 'creates a dsl setter method for the config class' do

    end
  end

  describe '.load' do

  end

  describe '.read' do

  end

end
