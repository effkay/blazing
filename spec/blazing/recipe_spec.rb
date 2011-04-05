require 'spec_helper'
require 'blazing/recipe'

describe Blazing::Recipe do

  context 'initializer' do
    it 'takes a string as name parameter' do
      recipe = Blazing::Recipe.new('some_recipe')
      recipe.name.should == 'some_recipe'
    end

    it 'takes a symbol as name parameter and converts it to a string' do
      recipe = Blazing::Recipe.new(:some_recipe)
      recipe.name.should == 'some_recipe'
    end

    it 'accepts options' do
      recipe = Blazing::Recipe.new(:some_recipe, :an_option => 'yeah')
      recipe.options[:an_option].should == 'yeah'
    end
  end

  context 'recipe discovery' do
    it 'before loading them, no recipes are known' do
      lambda { Blazing::RvmRecipe }.should raise_error NameError
    end

    it 'can discover available recipes' do
      recipes = Blazing::Recipe.list
      recipes.should be_all { |recipe| recipe.superclass.should == Blazing::Recipe }
      recipes.each { |r| Blazing.send(:remove_const, r.name.to_s.gsub(/^.*::/, '')) }
    end
  end

  context 'running recipes' do

    # before :each do
    #   @logger = double('logger').as_null_object
    # end

    it 'delegate running a recipe to the recipe implementation' do
      Blazing::Recipe.load_builtin_recipes
      Blazing::RvmRecipe.should_receive(:run)
      Blazing::Recipe.new(:rvm).run
    end

    it 'construct the correct classname to use from recie name' do
      Blazing::Recipe.new(:rvm).recipe_class.should == Blazing::RvmRecipe
    end

    it 'raise an error when a recipe has no run method defined' do
      class Blazing::BlahRecipe < Blazing::Recipe; end
      lambda { Blazing::Recipe.new(:blah).run }.should raise_error NoMethodError
    end

    context 'unknown recipe' do

      before :all do
        @unknown_recipe_name = :undefined
      end

      it 'does not crash when a recipe can not be loaded' do
        lambda { Blazing::Recipe.new(@unknown_recipe_name).run }.should_not raise_error
      end

      it 'logs an error when a recipe cant be loaded' do
        Blazing::LOGGER.should_receive(:error) # TODO: how should one do this?? .with("unable to laod #{@unknown_recipe_name} recipe")
        Blazing::Recipe.new(:undefined).run
      end
    end
  end


  context 'builtin recipes' do

    it 'include an rvm recipe' do
      lambda { Blazing::RvmRecipe }.should_not raise_error NameError
    end

    it 'include a bundler recipe' do
      lambda { Blazing::BundlerRecipe }.should_not raise_error NameError
    end
  end

end
