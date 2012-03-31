require 'spec_helper'
require 'blazing/config'
require 'blazing/runner'

describe '$ blazing init' do

  before :each do
    setup_sandbox
    Blazing::Runner.init
  end

  after :each do
    teardown_sandbox
  end

  it 'creates a config directory if none exists yet' do
    File.exists?('config').should be true
  end

  it 'creates a config file in config/blazing.rb' do
    File.exists?('config/blazing.rb').should be true
  end
end

