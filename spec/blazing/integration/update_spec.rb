require 'spec_helper'
require 'blazing/config'
require 'blazing/cli'

describe '$ blazing update' do
  before :each do
    setup_sandbox
    @config = Blazing::Config.new
    @config.targets << Blazing::Target.new(:production, "#{@sandbox_directory}/production", @config)
    @config.targets << Blazing::Target.new(:staging, "#{@sandbox_directory}/staging", @config)
    @cli = Blazing::CLI.new
    allow(Blazing::Config).to receive(:parse).and_return @config
    allow(Blazing::Config).to receive(:parse).and_return @config
  end

  after :each do
    teardown_sandbox
  end

  context 'when a target is specified' do
    before :each do
      capture(:stdout, :stderr) { @cli.setup(:production) }
      capture(:stdout, :stderr) { @cli.update(:production) }
    end

    it 'generates a post-receive hook based on the current blazing config' do
      expect(File.exist?('/tmp/post-receive')).to be true
    end

    it 'copies the generated post-receive hook to the target' do
      expect(File.exist?("#{@sandbox_directory}/production/.git/hooks/post-receive")).to be true
    end
  end

  context 'when all is specified as target' do
    it 'updates all targets' do
      capture(:stdout, :stderr) { @cli.setup('all') }
      capture(:stdout, :stderr) { @cli.update('all') }
      expect(File.exist?("#{@sandbox_directory}/production/.git/hooks/post-receive")).to be true
      expect(File.exist?("#{@sandbox_directory}/staging/.git/hooks/post-receive")).to be true
    end
  end
end
