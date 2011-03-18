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

    it 'should delegate running a recipe to the recipe implementation' do
      Blazing::Recipe.new(:rvm).run
    end
  end

end
