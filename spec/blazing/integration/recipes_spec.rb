require 'spec_helper'

describe '$ blazing recipes' do

  before :each do
    setup_sandbox
    class Blazing::Recipe::Dummy < Blazing::Recipe
      def run(target_options={})
        puts 'dummy recipe was run'
      end
    end
    @dummy_recipe = Blazing::Recipe::Dummy.new
    @config = Blazing::Config.new
    @config.target :production, @production_url
    @config.instance_variable_set('@recipes', [@dummy_recipe])
    @cli = Blazing::CLI.new
    Blazing::Config.stub(:parse).and_return @config
  end

  after :each do
    teardown_sandbox
  end

  it 'runs the configured recipes' do
    output = capture(:stdout) { @cli.recipes(:production) }
    output.should == "dummy recipe was run\n"
  end
end

