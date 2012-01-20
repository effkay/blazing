require 'spec_helper'

describe 'blazing recipes' do

  before :each do
    setup_sandbox
    class Blazing::Recipe::Dummy < Blazing::Recipe
      def run
        puts 'dummy recipe was run'
      end
    end
    @dummy_recipe = Blazing::Recipe::Dummy.new
    @config = Blazing::Config.new
    @config.target :production, @production_url
    @config.instance_variable_set('@recipes', [@dummy_recipe])
    @cli = Blazing::CLI.new
    Blazing::Runner.class_variable_set('@@config', @config)
  end

  after :each do
    teardown_sandbox
  end

  it 'runs the configured recipes' do
    capture(:stdout) { @cli.recipes(:production) }
    # File.exists?(@sandbox_directory + '/config/blazing.rb').should be true
    # capture(:stdout) { system 'ls' }.should == "dummy\n"
    # `blazing recipes`.should == 'da'
  end

end
