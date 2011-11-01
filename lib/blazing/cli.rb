require 'thor'

module Blazing
  class CLI < Thor

    default_task :help

    desc 'help', 'Shows this help screen'

    method_option :file,
      :type    => :string,
      :aliases => '-f',
      :banner  => 'Specify a configuration file'

    def help
      
    end

  end
end
