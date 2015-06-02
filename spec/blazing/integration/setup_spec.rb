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
    allow(Blazing::Config).to receive(:parse).and_return @config
  end

  after :each do
    teardown_sandbox
  end

  context 'when a target is specified' do
    before :each do
      capture(:stdout, :stderr) { @cli.setup(:production) }
    end

    it 'prepares the repository on the target location' do
      expect(File.exist?("#{@sandbox_directory}/production/.git")).to be true
    end

    it 'configures the repository to allow pushing to the checked out branch' do
      expect(Grit::Repo.new("#{@sandbox_directory}/production").config['receive.denycurrentbranch']).to eq('ignore')
    end
  end

  context 'when all is specified as target' do
    it 'updates all targets' do
      capture(:stdout, :stderr) { @cli.setup('all') }
      expect(File.exist?("#{@sandbox_directory}/production/.git/hooks/post-receive")).to be true
      expect(File.exist?("#{@sandbox_directory}/staging/.git/hooks/post-receive")).to be true
    end
  end
end
