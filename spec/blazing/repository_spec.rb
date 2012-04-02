require 'spec_helper'

module Blazing

  describe Repository do

    let(:shell_probe) { double(:shell, :run => nil) }

    describe '#setup' do
      it 'initializes and sets up the repository over ssh' do
        target = double(:target, :host => 'host', :user => 'user', :path => '/some/where')
        repository = Repository.new(target)
        repository.instance_variable_set(:@shell, shell_probe)

        shell_probe.should_receive(:run).with("ssh user@host 'mkdir /some/where; cd /some/where && git init && cd /some/where && git config receive.denyCurrentBranch ignore'")
        repository.setup
      end

      it 'initializes and sets up the repository locally when no host provided' do
        target = double(:target, :host => nil, :user => 'user', :path => '/some/where')
        repository = Repository.new(target)
        repository.instance_variable_set(:@shell, shell_probe)

        shell_probe.should_receive(:run).with("mkdir /some/where; cd /some/where && git init && cd /some/where && git config receive.denyCurrentBranch ignore")
        repository.setup
      end
    end

    describe '#add_git_remote' do

      let(:target) { double(:target, :host => 'host', :user => 'user', :path => '/some/where', :name => :foo, :location => '/url/for/git/remote') }
      let(:repository) { Repository.new(target) }
      let(:grit_object) { repository.instance_variable_get(:@grit_object) }

      it 'adds a git remote for the target' do
        repository.add_git_remote
        grit_object.config["remote.#{target.name}.url"].should == target.location
      end
    end
  end
end
