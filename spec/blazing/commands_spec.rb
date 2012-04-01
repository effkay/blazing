require 'spec_helper'
require 'blazing/commands'

module Blazing

  describe Commands do

    let(:config_instance) { Blazing::Config.new }

    let(:target_a) { double('target_a', :name => 'target_a', :update => nil, :setup => nil) }
    let(:target_b) { double('target_b', :name => 'target_b', :update => nil, :setup => nil) }
    let(:targets)  { [target_a, target_b] }

    let(:recipe_a) { double('recipe_a', :name => 'recipe_a', :run => nil) }
    let(:recipe_b) { double('recipe_b', :name => 'recipe_b', :run => nil) }
    let(:recipes)  { [recipe_a, recipe_b] }

    let(:config) do
      config = config_instance
      config.targets = targets
      config.recipes = recipes

      config
    end

    let(:commands) { Commands }
    let(:commands_instance) { commands.new }

    before :each do
      Config.stub(:parse).and_return(config)
    end

    describe '.new' do
      it 'reads to config file' do
        Config.should_receive(:parse).and_return(config)
        commands.new
      end
    end

    describe '#run' do
      it 'creates an instance of itself' do
        commands_instance.stub!(:dummy_command)
        commands.should_receive(:new).with({}).and_return(commands_instance)
        commands.run(:dummy_command)
      end

      it 'runs the specified command' do
        commands_instance.should_receive(:dummy_command)
        commands.stub(:new).with({}).and_return(commands_instance)
        commands.run(:dummy_command)
      end

      it 'raises an exception if the command does not exist' do
        pending 'Implement after reading exceptional Ruby ;-)'
      end
    end

    describe '#init' do
      it 'creates a config directory if it does not exist' do
        Dir.should_receive(:mkdir).with('config')
        File.stub(:exists?).and_return(false)
        File.stub(:open)
        commands.run(:init)
      end

      it 'creates a config file' do
        file = double('file').as_null_object
        File.should_receive(:open).with("config/blazing.rb", "wb").and_yield(file)
        commands.run(:init)
      end
    end

    describe '#setup' do
      it 'runs the setup method on the specified target' do
        target_a.should_receive(:setup)
        target_b.should_not_receive(:setup)
        commands.run(:setup, :target_name => target_a.name)
      end

      it 'does nothing when no target is specified' do
        target_a.should_not_receive(:setup)
        target_b.should_not_receive(:setup)
        commands.run(:setup)
      end

      it 'runs setup on all targets if "all" is specified' do
        target_a.should_receive(:setup)
        target_b.should_receive(:setup)
        commands.run(:setup, :target_name => 'all')
      end

      it 'runs the update command' do
        commands_instance.should_receive(:update)
        commands.stub(:new).with({}).and_return(commands_instance)
        commands.run(:setup)
      end
    end

    describe '#update' do
      it 'runs the update method on the specified target' do
        target_a.should_receive(:update)
        target_b.should_not_receive(:update)
        commands.run(:update, :target_name => target_a.name)
      end

      it 'does nothing when no target is specified' do
        target_a.should_not_receive(:update)
        target_b.should_not_receive(:update)
        commands.run(:update)
      end

      it 'runs update on all targets if "all" is specified' do
        target_a.should_receive(:update)
        target_b.should_receive(:update)
        commands.run(:update, :target_name => 'all')
      end
    end

    describe '#recipes' do
      it 'runs each recipe' do
        recipes.each { |r| r.should_receive(:run) }
        commands.run(:recipes)
      end
    end

    describe '#list' do
      it 'lists each recipe' do
        Blazing::Recipe.should_receive(:pretty_list)
        commands.run(:list)
      end
    end
  end
end

