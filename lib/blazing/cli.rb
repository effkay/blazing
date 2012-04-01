require 'thor'
require 'blazing/commands'

module Blazing
  class CLI < Thor

    default_task :help

    desc 'init', 'Generate a blazing config file'

    #
    # Bootstrap blazing by creating a sample config file
    #
    def init
      Blazing::Commands.run(:init)
    end

    desc 'setup [TARGET]', 'Setup local and remote repository/repositories for deployment'

    method_option :file,
      :type    => :string,
      :aliases => '-f',
      :banner  => 'Specify a configuration file'

    #
    # Setup a target to be deployed with blazing
    #
    def setup(target_name = nil)
      Blazing::Commands.run(:setup, :target_name => target_name, :options => options)
    end

    desc 'update [TARGET]', 'Re-Generate and uplaod hook based on current configuration'

    method_option :file,
      :type    => :string,
      :aliases => '-f',
      :banner  => 'Specify a configuration file'

    #
    # Update the target hook so it matches the settings in the config
    #
    def update(target_name = nil)
      Blazing::Commands.run(:update, :target_name => target_name, :options => options)
    end

    desc 'recipes [TARGET]', 'Run the recipes for the given target'

    #
    # Run the configured blazing recipes (used on remote machien)
    #
    def recipes(target_name)
      Blazing::Commands.run(:recipes, :target_name => target_name, :options => options)
    end

    desc 'list', 'List available recipes'

    #
    # List the available blazing recipes
    #
    def list
      Blazing::Commands.run(:list)
    end
  end
end
