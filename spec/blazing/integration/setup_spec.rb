require 'spec_helper'

  describe 'blazing setup' do

    before :each do
      setup_sandbox
      @config = Blazing::Config.new
      @config.target :production, "#{@sandbox_directory}/target"
      @config.target :staging, "#{@sandbox_directory}/staging"
      @cli = Blazing::CLI.new
      Blazing::Config.stub(:parse).and_return @config
    end

    after :each do
      teardown_sandbox
    end

    context 'when a target is specified' do

      before :each do
        capture(:stdout, :stderr) { @cli.setup(:production) }
      end

      it 'prepares the repository on the target location' do
        File.exists?("#{@sandbox_directory}/target/.git").should be true
      end

      it 'configures the repository to allow pushing to the checked out branch' do
        Grit::Repo.new("#{@sandbox_directory}/target").config['receive.denycurrentbranch'].should == 'ignore'
      end
    end

    context 'when :all is specified as target' do
      it 'updates all targets' do
        capture(:stdout, :stderr) { @cli.setup(:all) }
        File.exists?("#{@sandbox_directory}/target/.git/hooks/post-receive").should be true
        File.exists?("#{@sandbox_directory}/staging/.git/hooks/post-receive").should be true
      end
    end

 end
