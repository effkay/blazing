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

  context 'builtin recipes' do
    before :all do
      Blazing::Recipe.load_builtin_recipes
    end

    it 'include an rvm recipe' do
      lambda { Blazing::RvmRecipe }.should_not raise_error NameError
    end

    it 'include a bundler recipe' do
      lambda { Blazing::BundlerRecipe }.should_not raise_error NameError
    end
  end

  context 'running recipes' do
    it 'delegate running a recipe to the recipe implementation' do
      Blazing::RvmRecipe.should_receive(:run)
      Blazing::Recipe.new(:rvm).run
    end

    it 'construct the correct classname to use from recie name' do
      Blazing::Recipe.new(:rvm).recipe_class.should == Blazing::RvmRecipe
    end

    it 'raises an error when a recipe has no run method defined' do
      class Blazing::BlahRecipe < Blazing::Recipe; end
      lambda { Blazing::Recipe.new(:blah).run }.should raise_error NoMethodError
    end
  end

  context 'recipe discovery' do
    it 'can discover available recipes' do
      Blazing::Recipe.list.should be_all { |recipe| recipe.superclass.should == Blazing::Recipe }
    end
  end

end
