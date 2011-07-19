require 'spec_helper'
require 'blazing'
require 'fileutils'

describe 'blazing init' do

  before :each do
    @blazing_root = Dir.pwd
    @sandbox_directory = File.join(@blazing_root, 'spec/support/sandbox')
    @blazing =  Blazing::CLI::Base.new

    # Sometimes, when specs failed, the sandbox would stick around
    FileUtils.rm_rf(@sandbox_directory) if Dir.exists?(@sandbox_directory)

    # Setup Sandbox
    Dir.mkdir(@sandbox_directory)
    Dir.chdir(@sandbox_directory)

    # Setup empty repository
    @repository_dir = 'repo_without_config'
    Dir.mkdir(@repository_dir)
    Dir.chdir(@repository_dir)
    `git init`
  end

  after :each do
    Dir.chdir(@blazing_root)
    FileUtils.rm_rf(@sandbox_directory)
  end

  it 'creates the config directory if it does not exist' do
    silence(:stdout) { @blazing.init }
    Dir.exists?('config').should be true
  end

  it 'does not fail when config directory exists already' do
    silence(:stdout) { lambda { @blazing.init }.should_not raise_error }
  end

  it 'attempts to use the origin remote to setup the repository in the config' do
    @origin = 'git@github.com:someone/somerepo.git'
    `git remote add origin #{@origin}`
    silence(:stdout) { @blazing.init }
    Blazing::Config.parse.repository.should == @origin
  end

  it 'sets a dummy repository config when no remote was found' do
    silence(:stdout) { @blazing.init }
    Blazing::Config.parse.repository.should == 'user@host:/some/path'
  end

end
