require 'thor'
require 'blazing/commands'
require 'blazing/logger'
require 'blazing/version'

module Blazing
  class CLI < Thor
    default_task :help

    #
    # Bootstrap blazing by creating a sample config file
    #
    desc 'init', 'Generate a sample blazing config file'

    def init
      Blazing::Commands.run(:init)
    end

    #
    # Setup a target to be deployed with blazing
    #
    desc 'setup [TARGET]', 'Setup local and remote repository/repositories for deployment'

    method_option :file,
                  type: :string,
                  aliases: '-f',
                  banner: 'Specify a configuration file'

    def setup(target_name = nil)
      Blazing::Commands.run(:setup, target_name: target_name, cli_options: options)
    end

    #
    # Update the target hook so it matches the settings in the config
    #
    desc 'update [TARGET]', 'Re-Generate and upload hook based on current configuration'

    method_option :file,
                  type: :string,
                  aliases: '-f',
                  banner: 'Specify a configuration file'

    def update(target_name = nil)
      Blazing::Commands.run(:update, target_name: target_name, cli_options: options)
    end

    #
    # SSH to the server and cd into the app directory. Of course it also sets the appropriate RAILS_ENV
    #
    desc 'goto [TARGET]', 'Open ssh session on target. Use -c to specify a command to be run'

    method_option :run,
                  type: :string,
                  aliases: '-c',
                  banner: 'Specify a command'

    def goto(target_name)
      Blazing::Commands.run(:goto, target_name: target_name, cli_options: options)
    end

    #
    # Show blazing version
    #
    desc 'version', 'Show the blazing version'

    map %w(-v --version) => :version

    def version
      puts "blazing version #{ ::Blazing::VERSION }"
    end
  end
end
