require 'spec_helper'
require 'blazing/config'
require 'blazing/cli'
require 'blazing/dsl'

describe '$ blazing setup' do
  before :each do
    setup_sandbox
    @config = Blazing::Config.new
    @config.targets << Blazing::Target.new(:production, "#{@sandbox_directory}/production", @config)
    @config.targets << Blazing::Target.new(:staging, "#{@sandbox_directory}/staging", @config)
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
      File.exist?("#{@sandbox_directory}/production/.git").should be true
    end

    it 'configures the repository to allow pushing to the checked out branch' do
      Grit::Repo.new("#{@sandbox_directory}/production").config['receive.denycurrentbranch'].should == 'ignore'
    end
  end

  context 'when all is specified as target' do
    it 'updates all targets' do
      capture(:stdout, :stderr) { @cli.setup('all') }
      File.exist?("#{@sandbox_directory}/production/.git/hooks/post-receive").should be true
      File.exist?("#{@sandbox_directory}/staging/.git/hooks/post-receive").should be true
    end
  end
end
