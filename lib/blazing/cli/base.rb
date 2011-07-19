require 'thor'
require 'grit'
require 'blazing'
require 'blazing/logger'
require 'blazing/base'
require 'blazing/recipe'
require 'blazing/cli/create'

module Blazing
  module CLI
    class Base < Thor

      include Blazing::Base

      desc 'init', 'prepare project for blazing deploys'
      def init
        @task ||= Blazing::CLI::Create.new([repository_url])
        @task.invoke_all
      end

      desc 'setup TARGET_NAME', 'setup or update blazing on specified target and deploy'
      def bootstrap(target_name = nil)
        Blazing::Target.bootstrap(target_name)

        # TODO: Abstract this into module and load it where we need it. Methods / actions should have
        # a success and failure message
        if exit_status == 0
          log :success, "successfully bootstrapped target #{target_name}"
        else
          log :error, "failed bootstrapping target #{target_name}"
        end
      end

      desc 'deploy TARGET', 'deploy to TARGET'
      def deploy(target_name = nil)
        Blazing::Target.deploy(target_name)

        if exit_status == 0
          log :success, "successfully deployed target #{target_name}"
        else
          log :error, "failed deploying on target #{target_name}"
        end
      end

      desc 'recipes', 'List available recipes'
      def recipes
        Blazing::Recipe.list.each do |recipe|
          log :success, recipe.name
        end
        report
      end

      desc 'post_receive', 'trigger the post-receive actions'
      def post_receive(target_name = nil)
        Blazing::Target.post_receive(target_name)
      end
    end
  end
end
