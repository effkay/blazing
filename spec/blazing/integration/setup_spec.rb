require 'spec_helper'

  describe 'blazing setup' do

    before :each do
      setup_sandbox
      @config = Blazing::Config.new
      @config.target :production, "#{@sandbox_directory}/remote"
      @cli = Blazing::CLI.new
      Blazing::Config.stub(:parse).and_return @config
    end

    after :each do
      teardown_sandbox
    end

    it 'prepares the repository on the target location' do
      @output = capture(:stdout) { @cli.setup(:production) }
      File.exists?("#{@sandbox_directory}/remote/.git").should be true
    end

    it 'configures the repository to allow pushing to the checked out branch'
    it 'runs blazing update for the target'

 end
