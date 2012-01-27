require 'spec_helper'

  describe 'blazing setup' do

    before :each do
      setup_sandbox
      @config = Blazing::Config.new
      @config.target :production, "#{@sandbox_directory}/target"
      @cli = Blazing::CLI.new
      Blazing::Config.stub(:parse).and_return @config
      @output = capture(:stdout, :stderr) { @cli.setup(:production) }
    end

    after :each do
      teardown_sandbox
    end

    it 'prepares the repository on the target location' do
      File.exists?("#{@sandbox_directory}/target/.git").should be true
    end

    it 'configures the repository to allow pushing to the checked out branch' do
      Grit::Repo.new("#{@sandbox_directory}/target").config['receive.denycurrentbranch'].should == 'ignore'
    end

 end
