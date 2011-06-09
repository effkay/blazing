require 'spec_helper'
require 'blazing/recipes/bundler_recipe'

describe Blazing::BundlerRecipe do

  before :each do
    @recipe_without_options = Blazing::BundlerRecipe.new('bundler')
    @recipe_with_options = Blazing::BundlerRecipe.new('bundler', :flags => '--without=production')
    @runner = double('runner', :run => nil)
    @recipe_with_options.instance_variable_set('@runner', @runner)
    @recipe_without_options.instance_variable_set('@runner', @runner)
  end

  describe '#run' do
    it 'fails if there is no gemfile' do
      File.stub!(:exists?).and_return(false)
      @recipe_without_options.run.should be false
    end

    it 'runs bundle install with default options when no options given' do
      File.stub!(:exists?).and_return(true)
      @runner.should_receive(:run).with('bundle install --deployment')
      @recipe_without_options.run
    end

    it 'runs bundle install with the options supplied' do
      File.stub!(:exists?).and_return(true)
      @runner.should_receive(:run).with('bundle install --without=production')
      @recipe_with_options.run
    end
  end
end
