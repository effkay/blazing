require 'spec_helper'
require 'blazing/config'
require 'blazing/runner'
require 'grit'

describe 'blazing setup:local' do

  before :each do
    setup_sandbox
    @production_url = 'user@host:/some/where'
    @staging_url = 'user@host:/some/where/else'

    @config = Blazing::Config.new
    @config.target :production, @production_url
    @config.target :staging, @staging_url
    capture(:stdout) { Blazing::Runner.new(@config).exec('setup:local') }
  end

  after :each do
    teardown_sandbox
  end

  it 'adds a git remote for each target' do
    Grit::Repo.new(Dir.pwd).config['remote.production.url'].should == @production_url
  end

end
