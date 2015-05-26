require 'blazing/repository'
require 'blazing/hook'

module Blazing
  class Target
    include Blazing::Logger

    attr_accessor :name, :location, :options, :config

    def initialize(name, location, config, options = {})
      @name = name
      @location = location
      @config = config
      @options = options
      @target = self
    end

    #
    # Set up Repositories and Hook
    #
    def setup
      info "Setting up repository for #{name} in #{location}"
      Repository.new(self).setup
    end

    #
    # Update git remote and hook
    #
    def update
      Repository.new(self).add_git_remote
      Hook.new(self).setup
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
  end
end
