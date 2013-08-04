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

    it 'returns a target object if only one is present' do
      config = Blazing::Config.new
      config.target :sometarget, 'somewhere'
      config.default_target.name.should be :sometarget
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

    describe 'rake' do
      it 'takes the name of the rake task as argument' do
        @config.rake :post_deploy
        @config.rake_task.should == :post_deploy
      end
    end
  end
end
