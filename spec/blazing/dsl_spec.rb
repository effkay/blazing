require 'spec_helper'
require 'blazing/dsl'

module Blazing
  describe DSL do

    let(:dsl) { Blazing::DSL.new(config) }
    let(:config) { double("config") }

    describe 'target' do
      let(:config) { double("config", :targets => []) }

      it 'adds a target to the config object' do
        dsl.target :somename, 'someuser@somehost:/path/to/deploy/to'
        dsl.target :someothername, 'someuser@somehost:/path/to/deploy/to'
        expect(config.targets.size).to be 2
      end

      it 'does not allow the creation of two targets with the same name' do
        dsl.target :somename, 'someuser@somehost:/path/to/deploy/to'
        expect{dsl.target :somename, 'someuser@somehost:/path/to/deploy/to'}.to raise_error
        expect(config.targets.size).to be 1
      end
    end

    describe 'rake' do
      it 'sets the rake task to the given name' do
        expect(config).to receive(:rake_task=).with('some_task')
        dsl.rake 'some_task'
      end
    end

    describe 'env_script' do
      it 'sets the env script to the given path' do
        expect(config).to receive(:env_script=).with('/path/to/script')
        dsl.env_script '/path/to/script'
      end
    end

    describe 'rvm_scripts' do
      it 'is deprecated and outputs a warning' do
        expect(dsl).to receive(:warn)
        dsl.rvm_scripts '/path/to/script'
      end
    end

    describe 'rvm' do
      it 'is deprecated and outputs a warning' do
        expect(dsl).to receive(:warn)
        dsl.rvm '/path/to/script'
      end
    end

    describe 'recipes' do
      it 'is deprecated and outputs a warning' do
        expect(dsl).to receive(:warn)
        dsl.recipes '/path/to/script'
      end
    end
  end
end
