require 'spec_helper'
require 'blazing/config'
require 'blazing/runner'

describe 'blazing init' do

  before :each do
    setup_sandbox
    class Blazing::Recipe::Dummy < Blazing::Recipe
    end
    @dummy_recipe = Blazing::Recipe::Dummy.new
    @config = Blazing::Config.new
    @config.target :production, @production_url
    @config.instance_variable_set('@recipes', [@dummy_recipe])
    @runner = Blazing::Runner.new(@config)
  end

  after :each do
    teardown_sandbox
  end

  it 'runs the configured recipes' do
    @dummy_recipe.should_receive(:run)
    @runner.exec('recipes:run')
  end

end
