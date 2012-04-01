require 'grit'

module Blazing
  class Repository

    include Blazing::Logger

    def initialize(target)
      @target = target
      @shell = Blazing::Shell.new
    end

    def setup
      # TODO: Handle case where user is empty
      if @target.host
        @shell.run "ssh #{@target.user}@#{@target.host} '#{init_repository} && #{setup_repository}'"
      else
        @shell.run "#{init_repository} && #{setup_repository}"
      end
    end

    def add_git_remote
      repository = Grit::Repo.new(Dir.pwd)
      info "Adding new remote #{@target.name} pointing to #{@target.location}"
      repository.config["remote.#{@target.name}.url"] = @target.location
    end

    private

    #
    # Initialize an empty repository, so we can push to it
    #
    def init_repository
      # Instead of git init with a path, so it does not fail on older
      # git versions (https://github.com/effkay/blazing/issues/53)
      "mkdir #{@target.path}; cd #{@target.path} && git init"
    end

    #
    # Allow pushing to currently checked out branch
    #
    def setup_repository
      "cd #{@target.path} && git config receive.denyCurrentBranch ignore"
    end
  end
end
