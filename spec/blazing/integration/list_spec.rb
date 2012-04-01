require 'spec_helper'

describe '$ blazing list' do


  before :each do
    setup_sandbox
  end

  after :each do
    teardown_sandbox
  end

  it 'prints a list of the available recipes' do
    class Blazing::Recipe::Dummy < Blazing::Recipe
    end
    # TODO: Remove when DSL and config object are split and no class loading issues appear in specs
    #capture(:stdout) { Blazing::Runner.list }.should == "dummy\n"
    capture(:stdout) { Blazing::Runner.list }.should == "recipe_a\nrecipe_b\ndummy\n"
  end
end

