require 'grit'

module Blazing
  module Base

    def config
      @config ||= Blazing::Config.parse
    end

    def log(type, message)
      @logger ||= Blazing::Logger.new
      @logger.log(type, message)
    end

    def report
      @logger.report
    end

    #
    # Helper that wraps exitstatus of cli stuff
    #
    def exit_status
      @exit_status || $?.exitstatus
    end

    #
    # Try to read the default remote
    #
    def repository_url
      Grit::Repo.new(Dir.pwd).config['remote.origin.url'] || 'user@host:/some/path'
    end

  end
end
