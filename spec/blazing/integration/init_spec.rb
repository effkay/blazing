require 'spec_helper'
require 'blazing/config'
require 'blazing/commands'

describe '$ blazing init' do
  before :each do
    setup_sandbox
    Blazing::Commands.new.init
  end

  after :each do
    teardown_sandbox
  end

  it 'creates a config directory if none exists yet' do
    File.exist?('config').should be true
  end

  it 'creates a config file in config/blazing.rb' do
    File.exist?('config/blazing.rb').should be true
  end
end
