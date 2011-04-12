module Blazing
  module CLI
    class Base < Thor

      desc 'init', 'prepare project for blazing deploys'
      def init
        Blazing::CLI::Create.new.invoke_all
      end

      desc 'setup TARGET_NAME', 'setup or update blazing on specified target and deploy'
      def setup(target_name = nil)
        config = Blazing::Config.load
        target = config.find_target(target_name)
        LOGGER.info "setting up target #{target.name}"
        target.setup

        # TODO: Abstract this into module and load it where we need it. Methods / actions should have
        # a success and failure message
        if $?.exitstatus == 0
          LOGGER.success "successfully set up target #{target.name}"
        else
          LOGGER.error "failed setting up target #{target.name}"
        end
      end

      desc 'deploy TARGET', 'deploy to TARGET'
      def deploy(target_name = nil)
        config = Blazing::Config.load
        target = config.find_target(target_name)
        LOGGER.info "deploying target #{target.name}"
        target.deploy

        if $?.exitstatus == 0
          LOGGER.success "successfully deployed target #{target.name}"
        else
          LOGGER.error "failed deploying on target #{target.name}"
        end
      end

      desc 'recipes', 'List available recipes'
      def recipes
        Blazing::Recipe.list.each do |recipe|
          puts recipe.name
        end
      end

    end
  end
end
