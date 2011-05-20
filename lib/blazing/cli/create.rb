require 'thor'
require 'thor/group'

module Blazing
  module CLI
    class Create < Thor::Group

      desc 'create a blazing config file'

      include Thor::Actions

      def initialize(logger = Blazing::Logger.new)
        @logger = logger
        super
      end

      def self.source_root
        File.dirname(__FILE__)
      end

      def create_blazing_dir
        empty_directory Blazing::DIRECTORY
      end

      def create_config_file
        template 'templates/blazing.tt', Blazing::CONFIGURATION_FILE
        @logger.log :info, "Blazing config file has been created in #{Blazing::CONFIGURATION_FILE} with a default remote."
        @logger.log :info, "Check the config and then setup your remote with blazing setup REMOTE"
        @logger.report
      end

    end
  end
end
