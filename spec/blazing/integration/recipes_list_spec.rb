require 'spec_helper'
require 'blazing/config'
require 'blazing/runner'

describe 'blazing init' do

  before :each do
    setup_sandbox
  end

  after :each do
    teardown_sandbox
  end

  it 'prints a list of the available recipes' do
    class Blazing::Recipe::Dummy < Blazing::Recipe
    end
    capture(:stdout) { Blazing::Runner.new.exec('recipes:list') }.should == "dummy\n"
  end

end
