require 'spec_helper'
require 'blazing/config'
require 'blazing/runner'

describe 'blazing init' do

  before :each do
    @blazing_root = Dir.pwd
    @sandbox_directory = File.join(@blazing_root, '/tmp/blazing_sandbox')

    # Sometimes, when specs failed, the sandbox would stick around
    FileUtils.rm_rf(@sandbox_directory) if Dir.exists?(@sandbox_directory)

    # Setup Sandbox and cd into it
    Dir.mkdir(@sandbox_directory)
    Dir.chdir(@sandbox_directory)
    capture(:stdout) { Blazing::Runner.new({}).exec('init') }
  end

  after :each do
    # Teardown Sandbox
    Dir.chdir(@blazing_root)
    FileUtils.rm_rf(@sandbox_directory)
  end

  it 'creates a config directory if none exists yet' do
    Dir.exists?('config').should be true
  end

  it 'creates a config file in config/blazing.rb' do
    File.exists?('config/blazing.rb').should be true
  end

end
