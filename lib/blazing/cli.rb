require 'thor'
require 'blazing/runner'

module Blazing
  class CLI < Thor

    default_task :help

    desc 'init', 'Generate a blazing config file'
    def init
      Blazing::Runner.init
    end

    method_option :file,
      :type    => :string,
      :aliases => '-f',
      :banner  => 'Specify a configuration file'

    desc 'setup [TARGET]', 'Setup local and remote repository/repositories for deployment'
    def setup(target_name = nil)
      Blazing::Runner.setup(target_name, options)
    end

    method_option :file,
      :type    => :string,
      :aliases => '-f',
      :banner  => 'Specify a configuration file'

    desc 'update [TARGET]', 'Re-Generate and uplaod hook based on current configuration'
    def update(target_name = nil)
      Blazing::Runner.update(target_name, options)
    end

    desc 'recipes', 'Run the Recipes (used on remote machine)'
    def recipes(target_name)
      Blazing::Runner.recipes(target_name, options)
    end

    desc 'list', 'List available Recipes'
    def list
      Blazing::Runner.list
    end

  end
end
