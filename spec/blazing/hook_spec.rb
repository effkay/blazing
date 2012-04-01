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
  end
end
