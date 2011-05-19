require 'thor'
require 'thor/group'

module Blazing
  module CLI
    class Create < Thor::Group

      desc 'create a blazing config file'

      include Thor::Actions

      def self.source_root
        File.dirname(__FILE__)
      end

      def create_blazing_dir
        empty_directory Blazing::DIRECTORY
      end

      def create_config_file
        template 'templates/blazing.tt', Blazing::CONFIGURATION_FILE
        Blazing.log :info, "Blazing config file has been created in #{Blazing::CONFIGURATION_FILE} with a default remote."
        Blazing.log :info, "Check the config and then setup your remote with blazing setup REMOTE"
        Blazing.report
      end

    end
  end
end
