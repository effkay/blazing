require 'spec_helper'
require 'blazing/config'

describe Blazing::Config do

  let(:config) { Blazing::Config.new }

  describe '#initialize' do
    it 'takes the path of the config file as an argument' do
      config = Blazing::Config.new('/some/where/config.rb')
      expect(config.file).to eq '/some/where/config.rb'
    end

    it 'takes the default config path if no path is specified' do
      config = Blazing::Config.new
      expect(config.file).to eq 'config/blazing.rb'
    end
  end

  describe '.parse' do
    it 'returns a config object' do
      expect(Blazing::Config.parse('spec/support/empty_config.rb')).to be_a Blazing::Config
    end

    it 'creates a new DSL object and instance_evals the config file' do
      dsl_double = double('dsl double')
      expect(Blazing::DSL).to receive(:new).and_return(dsl_double)
      expect(dsl_double).to receive(:instance_eval)
      Blazing::Config.parse('spec/support/empty_config.rb')
    end

    it 'loads the actual data from the config file' do
      config = Blazing::Config.parse('spec/support/dummy_config.rb')
      expect(config.targets.size).to be 1
      expect(config.target(:staging)).to be_a Blazing::Target
    end
  end

  describe 'target' do
    it 'returns a target object if the target exists in config' do
      target = double('dummy_target', :name => 'foo')
      config.targets << target
      expect(config.target('foo')).to be target
    end

    it 'returns nil if the target does not exist in config' do
      expect(config.target('foo')).to be nil
    end
  end
end
