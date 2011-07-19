require 'blazing'
require 'blazing/object'
require 'blazing/config'
require 'blazing/bootstrap'

module Blazing
  class Target

    include Blazing::Target::Bootstrap

    attr_accessor :name, :recipes

    AVAILABLE_SETTINGS = [:deploy_to, :host, :user, :path, :default, :branch]

    class << self

      def bootstrap(name)
        target = config.find_target(name)
        runner = Blazing::Runner.new
        # TODO: Use a Wrapper to Net::SSH
        target.clone_repository
        target.setup_post_receive_hook
        setup target.name
      end

      def deploy(name)
        target = config.find_target(name)
        runner = Blazing::Runner.new
        deploy_command = "git push #{name}"
        deploy_command += " #{target.branch}:#{target.branch}" if target.branch

        # TODO: checkout branch if we pushed to a branch which is not checked out
        runner.run deploy_command
      end

      def setup(name)
        if name
          config.find_target(name).add_target_as_remote
        else
          config.targets.each do |target|
            target.add_target_as_remote
          end
        end
      end

      def post_receive(name)
        target = config.find_target(name)
        target.set_git_dir
        target.reset_head!
        @recipes.delete_if { |recipe| recipe.name == 'rvm' }
        target.run_recipes
      end

      def config
        Blazing::Config.parse
      end

      def runner
        Blazing::Runner.new
      end

    end

    def initialize(name, options = {})
      @name = name.to_s
      @logger = options[:_logger] ||= Blazing::Logger.new
      @runner = options[:_runner] ||= Blazing::Runner.new
      @hook = options[:_hook] ||= Blazing::CLI::Hook

      @config = options[:config] || Blazing::Config.parse

      @repository = @config.repository
      create_accessors_from_config(options)
      load_recipes
    end

    def create_accessors_from_config(options)
      assign_settings(options)
      parse_deploy_to_string unless @deploy_to.blank?
      ensure_mandatory_settings
    end

    def assign_settings(options)
      AVAILABLE_SETTINGS.each do |option|
        instance_variable_set("@#{option}", options[option])
        self.class.send(:attr_accessor, option)
      end
    end

    # If the :deploy_to option is set, user, host and path are overriden
    def parse_deploy_to_string
      @host = @deploy_to.scan(/@(.*):/).join
      @user = @deploy_to.scan(/(.*)@/).join
      @path = @deploy_to.scan(/:(.*)/).join
    end

    # Raise an error if one of the required options is still empty
    def ensure_mandatory_settings
      [:host, :user, :path].each do |option|
        raise "#{option} can't be blank!" if instance_variable_get("@#{option}").blank?
      end
    end

    def gemfile_present?
      File.exists? 'Gemfile'
    end

    def set_git_dir
      ENV['GIT_DIR'] = '.git'
    end

    def reset_head!
      @runner ||= Blazing::Runner.new
      @runner.run 'git reset --hard HEAD'
    end

    #
    # Called by post-receive hook to determine rvm usage
    #
    def use_rvm?
      @rvm_recipe = @recipes.find { |recipe| recipe.name == 'rvm' }
      @recipes.delete_if { |recipe| recipe.name == 'rvm' }
      if @rvm_recipe
        @rvm_recipe.options[:rvm_string]
      else
        'none'
      end
    end

    def load_recipes

      # TODO: For now, recipes can be assigned only in the global
      # namespace of the config. Make it possible for targets to
      # define recipes individually

      @recipes = @config.recipes if @recipes.blank?
      Blazing::Recipe.load_builtin_recipes
    end

    def run_recipes
      run_bootstrap_recipes
      @recipes.each do |recipe|
        recipe.run
      end
    end

    def run_bootstrap_recipes
      bundler = @recipes.find { |r| r.name == 'bundler' }
      if bundler
        bundler.run
        @recipes.delete_if { |r| r.name == 'bundler' }
      end
    end
  end
end
