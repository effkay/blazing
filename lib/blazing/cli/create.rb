require 'thor'
require 'thor/group'
require 'blazing/base'

module Blazing
  module CLI
    class Create < Thor::Group

      desc 'create a blazing config file'

      argument :repository

      include Thor::Actions
      include Blazing::Base

      def self.source_root
        File.dirname(__FILE__)
      end

      def create_blazing_dir
        empty_directory Blazing::DIRECTORY
      end

      def create_config_file
        template 'templates/blazing.tt', Blazing::CONFIGURATION_FILE
        log :info, "Blazing config file has been created in #{Blazing::CONFIGURATION_FILE} with a default remote."
        log :info, "Check the config and then setup your remote with blazing setup REMOTE"
        report
      end
    end
  end
end
