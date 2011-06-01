require 'thor'
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
        @task ||= Blazing::CLI::Create.new
        @task.invoke_all
      end

      desc 'setup TARGET_NAME', 'setup or update blazing on specified target and deploy'
      def setup(target_name = nil)
        target = config.find_target(target_name)
        log :info, "setting up target #{target.name}"
        target.setup

        # TODO: Abstract this into module and load it where we need it. Methods / actions should have
        # a success and failure message
        if exit_status == 0
          log :success, "successfully set up target #{target.name}"
        else
          log :error, "failed setting up target #{target.name}"
        end
      end

      desc 'deploy TARGET', 'deploy to TARGET'
      def deploy(target_name = nil)
        target = config.find_target(target_name)
        log :info, "deploying target #{target.name}"
        target.deploy

        if exit_status == 0
          log :success, "successfully deployed target #{target.name}"
        else
          log :error, "failed deploying on target #{target.name}"
        end
      end

      desc 'recipes', 'List available recipes'
      def recipes
        Blazing::Recipe.list.each do |recipe|
          log :success, recipe.name
        end
        report
      end

      #TODO: move post_recevie and rvm somewhere else, they must only be called by the
      # post-receive hook and not visible to user

      desc 'post_receive', 'trigger the post-receive actions'
      def post_receive(target_name = nil)
        target = config.find_target(target_name)
        Blazing::Remote.new(target.name).post_receive
      end

      desc 'rvm', 'used by post_receive hook to decide if rvm env needs to be switched'
      def rvm(target_name = nil)
        target = config.find_target(target_name)
        log :info, Blazing::Remote.new(target.name).use_rvm?
        report
      end

    private

      def exit_status
        @exit_status || $?.exitstatus
      end
    end
  end
end
