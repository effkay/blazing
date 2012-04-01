require 'blazing/shell'
require 'grit'

module Blazing

  class Target

    include Blazing::Logger

    attr_accessor :name, :location, :options, :config

    def initialize(name, location, config, options = {})
      @name = name
      @location = location
      @config = config
      @options = options
      @shell = Blazing::Shell.new
      @target = self
    end

    #
    # Set up Repositories and Hook
    #
    def setup
      info "Setting up repository for #{name} in #{location}"

      # TODO: Handle case where user is empty
      if host
        @shell.run "ssh #{user}@#{host} '#{init_repository} && #{setup_repository}'"
      else
        @shell.run "#{init_repository} && #{setup_repository}"
      end
    end

    #
    # Update git remote and hook
    #
    def update
      setup_git_remote
      setup_hook
    end

    def path
      if host
        @location.match(/:(.*)$/)[1]
      else
        @location
      end
    end

    def host
      host = @location.match(/@(.*):/)
      host[1] unless host.nil?
    end

    def user
      user = @location.match(/(.*)@/)
      user[1] unless user.nil?
    end

    private

    #
    # Set up and deploy Hook
    #
    def setup_hook
      Hook.new(self).setup
    end

    #
    # Add git remote for target
    #
    def setup_git_remote
      repository = Grit::Repo.new(Dir.pwd)
      info "Adding new remote #{name} pointing to #{location}"
      repository.config["remote.#{name}.url"] = location
    end

    #
    # Initialize an empty repository, so we can push to it
    #
    def init_repository
      # Instead of git init with a path, so it does not fail on older
      # git versions (https://github.com/effkay/blazing/issues/53)
      "mkdir #{path}; cd #{path} && git init"
    end

    #
    # Allow pushing to currently checked out branch
    #
    def setup_repository
      "cd #{path} && git config receive.denyCurrentBranch ignore"
    end
  end
end

