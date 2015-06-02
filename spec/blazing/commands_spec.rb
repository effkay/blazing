require 'spec_helper'
require_relative '../../lib/blazing/commands'
require_relative '../../lib/blazing/config'

module Blazing
  describe Commands do
    let(:config_instance) { Blazing::Config.new }

    let(:target_a) { double('target_a', name: 'target_a', update: nil, setup: nil) }
    let(:target_b) { double('target_b', name: 'target_b', update: nil, setup: nil) }
    let(:targets)  { [target_a, target_b] }

    let(:config) do
      config = config_instance
      config.targets = targets

      config
    end

    let(:commands) { Commands }
    let(:commands_instance) { commands.new }

    before :each do
      allow(Config).to receive(:parse).and_return config
    end

    describe '.new' do
      it 'reads the config file when the command requires it' do
        expect(Config).to receive(:parse).and_return config
        commands.new(command: :setup)
      end

      it 'does not read the config file when the command does not need it' do
        expect(Config).not_to receive(:parse)
        commands.new(command: :init)
      end
    end

    describe '#run' do
      it 'creates an instance of itself' do
        allow(commands_instance).to receive :dummy_command
        expect(commands).to receive(:new).with(command: :dummy_command).and_return(commands_instance)
        commands.run(:dummy_command)
      end

      it 'runs the specified command' do
        expect(commands_instance).to receive(:dummy_command)
        allow(commands).to receive(:new).with(command: :dummy_command).and_return(commands_instance)
        commands.run(:dummy_command)
      end
    end

    describe '#init' do
      it 'creates a config directory if it does not exist' do
        expect(Dir).to receive(:mkdir).with('config')
        allow(File).to receive(:exist?).and_return(false)
        allow(File).to receive(:open)
        commands.run(:init)
      end

      it 'creates a config file' do
        file = double('file').as_null_object
        expect(File).to receive(:open).with('config/blazing.rb', 'wb').and_yield(file)
        commands.run(:init)
      end
    end

    describe '#setup' do
      it 'runs the setup method on the specified target' do
        expect(target_a).to receive(:setup)
        expect(target_b).not_to receive(:setup)
        commands.run(:setup, target_name: target_a.name)
      end

      it 'does nothing when no target is specified' do
        expect(target_a).not_to receive(:setup)
        expect(target_b).not_to receive(:setup)
        commands.run(:setup)
      end

      it 'runs setup on all targets if "all" is specified' do
        expect(target_a).to receive(:setup)
        expect(target_b).to receive(:setup)
        commands.run(:setup, target_name: 'all')
      end

      it 'runs the update command' do
        expect(commands_instance).to receive(:update)
        allow(commands).to receive(:new).and_return(commands_instance)
        commands.run(:setup)
      end
    end

    describe '#update' do
      it 'runs the update method on the specified target' do
        expect(target_a).to receive(:update)
        expect(target_b).not_to receive(:update)
        commands.run(:update, target_name: target_a.name)
      end

      it 'does nothing when no target is specified' do
        expect(target_a).not_to receive(:update)
        expect(target_b).not_to receive(:update)
        commands.run(:update)
      end

      it 'runs update on all targets if "all" is specified' do
        expect(target_a).to receive(:update)
        expect(target_b).to receive(:update)
        commands.run(:update, target_name: 'all')
      end
    end
  end
end
