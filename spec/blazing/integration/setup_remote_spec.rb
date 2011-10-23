require 'spec_helper'
require 'blazing/config'
require 'blazing/runner'
require 'grit'

describe 'blazing setup:remote' do

  before :each do
    setup_sandbox
    @production_url = 'user@host:/some/where'
    @staging_url = 'user@host:/some/where/else'

    @config = Blazing::Config.new
    @config.target :production, @production_url
    @config.target :staging, @staging_url, :default => true
    capture(:stdout) { Blazing::Runner.new(@config).exec('setup:remote') }
  end

  after :each do
    teardown_sandbox
  end

  it 'generates the hook' do
    File.exists?('/tmp/post-receive').should be true
  end

end
