require 'spec_helper'
require 'blazing/config'

describe Blazing::Config do

  describe '#initialize' do
    it 'takes the path of the config file as an argument' do
      config = Blazing::Config.new('/some/where/config.rb')
      config.file.should == '/some/where/config.rb'
    end

    it 'takes the default config path if no path is specified' do
      config = Blazing::Config.new
      config.file.should == 'config/blazing.rb'
    end
  end

  describe '.parse' do

    it 'returns a config object' do
      Blazing::Config.parse('spec/support/empty_config.rb').should be_a Blazing::Config
    end

  end

  describe '#default_target' do

    it 'retunrs a target object if only one is present' do
      config = Blazing::Config.new
      config.target :sometarget, 'somewhere'
      config.default_target.name.should be :sometarget
    end

    context 'when more than 1 target defined in config' do

      it 'raises an error when none is default' do
        config = Blazing::Config.new
        config.target :sometarget, 'somewhere'
        config.target :someothertarget, 'somewhere'
        lambda { config.default_target }.should raise_error
      end

      it 'retunrs the target object with :default => true option if more than 1 target present' do
        config = Blazing::Config.new
        config.target :sometarget, 'somewhere', :default => true
        config.target :someothertarget, 'somewhere'
        config.default_target.name.should be :sometarget
      end

    end
  end

  describe 'DSL' do

    before :each do
      @config = Blazing::Config.new
    end

    describe 'target' do

      it 'creates a target object for each target call' do
        @config.target :somename, 'someuser@somehost:/path/to/deploy/to'
        @config.target :someothername, 'someuser@somehost:/path/to/deploy/to'

        @config.targets.each { |t| t.should be_a Blazing::Target }
        @config.targets.size.should be 2
      end

      it 'does not allow the creation of two targets with the same name' do
        @config.target :somename, 'someuser@somehost:/path/to/deploy/to'
        lambda { @config.target :somename, 'someuser@somehost:/path/to/deploy/to' }.should raise_error
      end
    end

    describe 'repository' do
      it 'assigns the repository if a value is given' do
        @config.repository('somewhere')
        @config.instance_variable_get("@repository").should == 'somewhere'
      end

      it 'returns the repository string if no value is given' do
        @config.repository('somewhere')
        @config.repository.should == 'somewhere'
      end
    end

    describe 'recipes' do

      before :each do
        class Blazing::Recipe::Dummy < Blazing::Recipe
        end
      end

      it 'is an empty recipe if nothing was set' do
        @config.recipes.should be_a Array
      end

      it 'accepts a single recipe as argument' do
        @config.recipes :dummy
        @config.recipes.first.should be_a Blazing::Recipe::Dummy
      end

      it 'accepts an array of recipes as argument' do
        @config.recipes [:dummy, :dummy]
        @config.recipes.size.should be 2
        @config.recipes.each { |r| r.should be_a Blazing::Recipe::Dummy }
      end
    end

    describe 'rake' do

      it 'takes the name of the rake task as argument' do
        @config.rake :post_deploy
        @config.instance_variable_get('@rake').should be :post_deploy
      end

      it 'returns the name of the task if no argument given' do
        @config.rake :post_deploy
        @config.rake.should be :post_deploy
      end

    end

    describe 'rvm' do

      it 'takes an rvm string as argument' do
        @config.rvm 'ruby-1.9.2@rails31'
        @config.instance_variable_get('@rvm').should == 'ruby-1.9.2@rails31'
      end

      it 'returns the rvm string if no argument given' do
        @config.rvm 'ruby-1.9.2@rails31'
        @config.rvm.should == 'ruby-1.9.2@rails31'
      end

    end
  end
end
