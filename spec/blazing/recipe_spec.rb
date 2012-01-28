require 'spec_helper'
require 'blazing/recipe'

describe Blazing::Recipe do

  describe '.init_by_name' do
    before :each do
      class Blazing::Recipe::Dummy < Blazing::Recipe
        def run(target_options = {})
          super target_options
        end
      end
    end

    it 'initializes the correct recipe' do
      Blazing::Recipe.init_by_name(:dummy).should be_a Blazing::Recipe::Dummy
    end
  end

  describe '.list' do
    it 'retunrs an array of the available recipe classes' do
      Blazing::Recipe.list.first.should == Blazing::Recipe::Dummy
    end
  end

  describe '#run' do

    before :each do
      @production_url = '/some/target'
      @dummy_recipe = Blazing::Recipe::Dummy.new(:some_option => 'global')
      @config = Blazing::Config.new
      @config.target(:production, @production_url, :some_option => 'target-specific')
      @config.instance_variable_set('@recipes', [@dummy_recipe])
    end

    it 'overrides global recipe options with target options' do
      @dummy_recipe.run(:some_option => 'target-specific')
      @dummy_recipe.instance_variable_get('@options')[:some_option].should == 'target-specific'
    end
  end

end
