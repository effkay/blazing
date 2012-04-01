require 'spec_helper'
require 'blazing/commands'

module Blazing

  describe Commands do

    let(:config_instance) { Blazing::Config.new }

    let(:config) do

      config = config_instance

      # TODO: Split dsl and config object so i can access stuff directly and mock better
      config.target :target_a, 'somewhere'
      config.target :target_b, 'somewhere'
      config.recipe :recipe_a
      config.recipe :recipe_b

      config
    end

    let(:commands) { Commands }
    let(:commands_instance) { commands.new }

    before :each do
      # TODO: Big Codesmell that I have to define those here!
      class Recipe::RecipeA < Blazing::Recipe; end
      class Recipe::RecipeB < Blazing::Recipe; end
      Config.stub(:parse).and_return(config)
      #config.instance.stub(:recipe).and_return()
    end

    after :each do
      #Recipe
      #Recipe.send(:class)
      #Recipe.send(:remove_const, :RecipeB)
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
        commands.run(:init)
      end

      it 'creates a config file' do
        file = double('file').as_null_object
        File.should_receive(:open).with("config/blazing.rb", "wb").and_yield(file)
        commands.run(:init)
      end
    end

    describe '#setup' do
      let(:targets) { config.instance_variable_get('@targets') }
      let(:specified_target) { targets.find { |t| t.name == :target_a } }
      let(:other_target) { targets.find { |t| t.name == :target_b } }

      it 'runs the setup method on the specified target' do
        specified_target.should_receive(:setup)
        other_target.should_not_receive(:setup)
        commands.run(:setup, :target_name => specified_target.name)
      end

      it 'does nothing when no target is specified' do
        specified_target.should_not_receive(:setup)
        other_target.should_not_receive(:setup)
        commands.run(:setup)
      end

      it 'runs setup on all targets if "all" is specified' do
        specified_target.should_receive(:setup)
        other_target.should_receive(:setup)
        commands.run(:setup, :target_name => 'all')
      end

      it 'runs the update command' do
        commands_instance.should_receive(:update)
        commands.stub(:new).with({}).and_return(commands_instance)
        commands.run(:setup)
      end
    end

    describe '#update' do
      let(:targets) { config.instance_variable_get('@targets') }
      let(:specified_target) { targets.find { |t| t.name == :target_a } }
      let(:other_target) { targets.find { |t| t.name == :target_b } }

      it 'runs the update method on the specified target' do
        specified_target.should_receive(:update)
        other_target.should_not_receive(:update)
        commands.run(:update, :target_name => specified_target.name)
      end

      it 'does nothing when no target is specified' do
        specified_target.should_not_receive(:update)
        other_target.should_not_receive(:update)
        commands.run(:update)
      end

      it 'runs update on all targets if "all" is specified' do
        specified_target.should_receive(:update)
        other_target.should_receive(:update)
        commands.run(:update, :target_name => 'all')
      end
    end

    describe '#recipes' do
      let(:recipes) { config.instance_variable_get('@recipes') }

      it 'runs each recipe' do
        recipes.each { |r| r.should_receive(:run) }
        commands.run(:recipes)
      end
    end

    describe '#list' do
      let(:recipes) { config.instance_variable_get('@recipes') }

      it 'lists each recipe' do
        Blazing::Recipe.should_receive(:pretty_list)
        commands.run(:list)
      end
    end
  end
end

