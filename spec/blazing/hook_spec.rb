require 'spec_helper'

module Blazing

  describe Hook do

    let(:config) { Config.new }

    describe '#rake_command' do
      it 'prepends the environment variables specified in the rake call' do
        config.rake :deploy, 'SOMEFUNKYVARIABLE=foobar'
        target = Blazing::Target.new(:sometarget, '/path', config)
        hook = Hook.new(target)
        hook.rake_command.should == 'SOMEFUNKYVARIABLE=foobar  bundle exec rake deploy'
      end

      it 'appends the RAILS_ENV specified as :rails_env option to the target call' do
        config.rake :deploy
        target = Blazing::Target.new(:sometarget, '/path', config, :rails_env => 'production')
        hook = Hook.new(target)
        hook.rake_command.should == ' RAILS_ENV=production bundle exec rake deploy'
      end

      it 'returns nil when no rake task was specified in config' do
        target = Blazing::Target.new(:sometarget, '/path', config, :rails_env => 'production')
        hook = Hook.new(target)
        hook.rake_command.should be nil
      end
    end

    describe 'Generated Hook' do
      context 'Always' do
        let(:target) { Blazing::Target.new(:sometarget, '/path', config, :rails_env => 'production') }
        let(:hook_file) { Hook.new(target).send(:generate_hook) }

        it 'logs the header with the target name' do
          hook_file.should  include("ENTERING POST RECEIVE HOOK FOR: sometarget")
        end

        it 'goes one directory up' do
          hook_file.should include('cd ..')
        end

        it 'sets the GIT_DIR variable to .git' do
          hook_file.should include("GIT_DIR='.git'")
        end

        it 'does a hard reset' do
          hook_file.should include("git reset --hard HEAD")
        end

        it 'checks out the pushed branch' do
          hook_file.should include("git checkout $refname")
        end

        it 'runs bundler with the correct options' do
          hook_file.should include("bundle --deployment --quiet --without development test")
        end
      end

      context 'RVM Setup' do
        context 'when rvm is enabled' do
          context 'when the rvm scripts are in the default locations' do
            it 'uses the load mechanism suggested by rvm'
          end

          context 'when rvm_scripts is set' do
            it 'sources the rvm_scripts directory'
          end

          context 'when rvm is set to load from rvmrc' do
            'it sources the rvmrc to load the env'
          end

          context 'when an rvm string was specified' do
            it 'uses rvm use to load the env'
          end
        end

        context 'when rvm is disabled' do
          it 'does not include any rvm handling'
        end
      end

      context 'Recipes Handling' do
        context 'when there are no recipes configured' do
          it 'does not run blazing recipes'
        end

        context 'when there are recipes configured' do
          it 'runs the blazing recipes command with the correct target name'
        end
      end

      context 'Rake Command Handling' do
        context 'when the rake_command is specified' do
          it 'runs the rake command'
        end
        context 'when no rake_command is specified' do
          it 'does not run the rake_command'
        end
      end
    end
  end
end
