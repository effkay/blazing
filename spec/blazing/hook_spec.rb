require 'spec_helper'
require 'blazing/hook'
require 'blazing/config'

module Blazing

  describe Hook do

    let(:config) { Blazing::Config.new }

    describe '#rake_command' do
      it 'prepends the RAILS_ENV specified as :rails_env option to the target call' do
        config.rake_task = :deploy
        target = Blazing::Target.new(:sometarget, '/path', config, :rails_env => 'production')
        hook = Hook.new(target)
        hook.rake_command.should == 'RAILS_ENV=production bundle exec rake deploy'
      end

      it 'prepends the any other option specified specified in the target call' do
        config.rake_task = :deploy
        target = Blazing::Target.new(:sometarget, '/path', config, :rails_env => 'production', :foo => 'bar')
        hook = Hook.new(target)
        hook.rake_command.should include('RAILS_ENV=production')
        hook.rake_command.should include('FOO=bar')
        hook.rake_command.should include('bundle exec rake deploy')
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

      context 'env script' do
        it 'sources the specified directory when env_script is specified' do
          config.env_script = '/location/of/script'
          hook_file.should include("source /location/of/script")
        end
      end

      context 'Rake Command Handling' do
        context 'when the rake_command is specified' do
          before :each do
            config.rake_task = :deploy
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

