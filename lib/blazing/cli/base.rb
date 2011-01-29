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
      desc 'setup TARGET', 'setup or update blazing on specified target and deploy'
      def setup(target = nil)

        config = Blazing::Config.load
        puts config.repository
        #puts Blazing::Config::determine_target(target).name

        #say 'NO TARGET SPECIFIED AND NO DEFAULT TARGET FOUND', :red
        #config = Blazing::Config.read do
        #  self.instance_eval(File.read file)
          #self.target :dada do
          #  'asdasd'
          #end

        #end

        #puts config.repository

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
