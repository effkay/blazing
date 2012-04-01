require 'spec_helper'

describe '$ blazing list' do


  before :each do
    setup_sandbox
  end

  after :each do
    teardown_sandbox
  end

  it 'prints a list of the available recipes' do
    class Blazing::Recipe::Dummy < Blazing::Recipe
    end
    capture(:stdout) { Blazing::Commands.new(:file => File.join(File.dirname(__FILE__), '../../support/empty_config.rb')).list }.should == "dummy\n"
  end
end

