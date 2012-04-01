require 'spec_helper'
require 'blazing/config'

describe '$ blazing init' do

  before :each do
    setup_sandbox
    Blazing::Commands.new(:file => File.join(File.dirname(__FILE__), '../../support/empty_config.rb')).init
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

