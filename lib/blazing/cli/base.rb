module Blazing
  module CLI
    class Base < Thor

      #
      # Configure blazing in current working dir
      #
      desc 'init', 'prepare project for blazing deploys'
      def init
        target = ask "Deployment Target: (ie username@host:/path/to/app)"
        origin = `git remote show origin|grep "Fetch URL"`.split[2]
        if yes? "Get code from here: #{origin} ?"
          repository = origin
        else
          repository = ask "Repository URL: (ie username@host:/path/to/app)"
        end
        
        Blazing::CLI::Create.new([repository, target]).invoke
      end

      #
      # Setup target for deployment
      #
      desc 'setup TARGET_NAME', 'setup or update blazing on specified target and deploy'
      def setup(target_name = nil)
        config = Blazing::Config.load
        target = config.find_target(target_name)
        LOGGER.info "setting up target #{target.name}"
        target.setup
      end

      #
      # Deploy to target
      #
      desc 'deploy TARGET', 'deploy to TARGET'
      def deploy(target = nil)

      end

    end
  end
end
