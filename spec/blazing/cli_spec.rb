require 'spec_helper'
require 'blazing/cli'

module Blazing

  describe CLI do

    let(:cli) { CLI.new }
    it 'has an init method' do
      cli.respond_to? :init
    end

    it 'has a setup method' do
      cli.respond_to? :setup
    end

    it 'has an update method' do
      cli.respond_to? :update
    end

    it 'has a help method' do
      cli.respond_to? :help
    end
  end
end

