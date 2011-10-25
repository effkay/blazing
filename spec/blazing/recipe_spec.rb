require 'spec_helper'
require 'blazing/recipe'

describe Blazing::Recipe do

  describe '.init_by_name' do
    before :each do
      class Blazing::Recipe::Dummy < Blazing::Recipe
      end
    end

    it 'initializes the correct recipe' do
      Blazing::Recipe.init_by_name(:dummy).should be_a Blazing::Recipe::Dummy
    end
  end

  describe '.list' do
    it 'retunrs an array of the available recipe classes' do
      Blazing::Recipe.list.first.should be Blazing::Recipe::Dummy
    end
  end

  describe '.parse_gemfile' do

    it 'works when the recipe gems are specified with versions' do
      gemfile = 'spec/support/gemfile_with_versions'
      Blazing::Recipe.parse_gemfile(gemfile).should == ["blazing-passenger", "blazing-rails"]
    end

    it 'works when the recipe gems are specified without' do
      gemfile = 'spec/support/gemfile_without_versions'
      Blazing::Recipe.parse_gemfile(gemfile).should == ["blazing-passenger", "blazing-rails"]
    end

    it 'does not load gems that are commented out' do
      pending
      gemfile = 'spec/support/gemfile_with_comments'
      Blazing::Recipe.parse_gemfile(gemfile).should == ["blazing-passenger"]
    end

  end

end
