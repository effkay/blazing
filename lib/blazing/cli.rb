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

    desc 'goto [TARGET]', 'Open a shell for specified target'

    method_option :run,
      :type    => :string,
      :aliases => '-c',
      :banner  => 'Specify a command'

    #
    # SSH to the server and cd into the app directory. Of course it also sets the appropriate RAILS_ENV
    #
    def goto(target_name)
      Blazing::Commands.run(:goto, :target_name => target_name, :options => options)
    end
  end
end
