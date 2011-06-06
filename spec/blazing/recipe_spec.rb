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

    around :each do |example|
      # Make sure specs dont interfere with recipe discovery mechanism
      recipes = Blazing::Recipe.list
      recipes.each { |r| Blazing.send(:remove_const, r.name.to_s.gsub(/^.*::/, '')) rescue NameError }
      example.run
      recipes.each { |r| Blazing.send(:remove_const, r.name.to_s.gsub(/^.*::/, '')) rescue NameError }
    end

    it 'before loading them, no recipes are known' do
      lambda { Blazing::RvmRecipe }.should raise_error NameError
    end

    it 'can discover available recipes' do
      recipes = Blazing::Recipe.list
      recipes.should be_all { |recipe| recipe.superclass.should == Blazing::Recipe }
    end

  end

  context 'running recipes' do

    it 'construct the correct classname to use from recie name' do
      Blazing::Recipe.load_builtin_recipes
      Blazing::Recipe.new(:rvm).recipe_class.should == Blazing::RvmRecipe
    end

    it 'raise an error when a recipe has no run method defined' do
      class Blazing::BlahRecipe < Blazing::Recipe; end
      lambda { Blazing::Recipe.new(:blah).run }.should raise_error RuntimeError
    end

    context 'unknown recipe' do
      pending "Handle errors for loading unknown recipes"
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
