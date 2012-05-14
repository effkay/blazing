require 'spec_helper'

module Blazing

  class Recipe::Dummy < Blazing::Recipe
  end

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

      let(:target) { Blazing::Target.new(:sometarget, '/path', config, :rails_env => 'production') }
      let(:hook_file) { Hook.new(target).send(:generate_hook) }

      context 'Always' do
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

        it 'resets the GIT_DIR variable' do
          hook_file.should include("unset GIT_DIR")
        end

        it 'resets the GIT_WORK_TREE variable' do
          hook_file.should include("unset GIT_WORK_TREE")
        end

        it 'runs bundler with the correct options' do
          hook_file.should include("bundle --deployment --quiet --without development test")
        end
      end

      context 'RVM Setup' do
        context 'when rvm is enabled' do
          context 'loading rvm' do
            it 'uses the load mechanism suggested by rvm' do
              config.rvm 'someruby@somegemset'
              hook_file.should include("source \"$HOME/.rvm/scripts/rvm\"")
              hook_file.should include("source \"/usr/local/rvm/scripts/rvm\"")
            end

            it 'sources the rvm_scripts directory when rvm_scripts is specified' do
              config.rvm 'someruby@somegemset'
              config.rvm_scripts '/location/of/rvm/scripts'
              hook_file.should include("source /location/of/rvm/scripts")
            end
          end

          context 'loading the rvm ruby and gemset' do
            it 'sources the rvmrc to load the env' do
              config.rvm 'someruby@somegemset'
              hook_file.should include("rvm use someruby@somegemset")
            end

            it 'uses rvm use to load the env when an rvm string was specified' do
              config.rvm :rvmrc
              hook_file.should include("source .rvmrc")
            end
          end
        end

        context 'when rvm is disabled' do
          it 'does not include any rvm handling' do
            hook_file.should_not include("Loading rvm")
          end
        end
      end

      context 'Recipes Handling' do

        context 'when there are no recipes configured' do
          it 'does not run blazing recipes' do
            hook_file.should_not include("bundle exec blazing recipes")
          end
        end

        context 'when there are recipes configured' do
          before :each do
            config.recipe :dummy
          end

          it 'runs the blazing recipes command with the correct target name' do
            hook_file.should include("bundle exec blazing recipes sometarget")
          end
        end
      end

      context 'Rake Command Handling' do
        context 'when the rake_command is specified' do
          before :each do
            config.rake :deploy
          end

          it 'runs the rake command' do
            hook_file.should include(' RAILS_ENV=production bundle exec rake deploy')
          end
        end

        context 'when no rake_command is specified' do
          it 'does not run the rake_command' do
            hook_file.should_not include(" RAILS_ENV=production bundle exec rake")
          end
        end
      end
    end
  end
end

