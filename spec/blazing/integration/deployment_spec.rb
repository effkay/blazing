require 'spec_helper'

describe 'deployment with git push' do

    before :each do
      setup_sandbox
      #@config = Blazing::Config.new
      #@config.target :production, "#{@sandbox_directory}/target"
      #@config.target :staging, "#{@sandbox_directory}/staging"
      #@cli = Blazing::CLI.new
      #Blazing::Config.stub(:parse).and_return @config
    end

    after :each do
      teardown_sandbox
    end

    context 'git push <remote> <ref>' do
      it 'deploys the pushed ref'
    end

    context 'git push <remote>' do
      context 'when one ref is pushed' do
        it 'deploys the pushed ref'
      end

      context 'when multiple refs are pushed' do
        it 'deploys the currently checked out ref'
      end
    end
 end

