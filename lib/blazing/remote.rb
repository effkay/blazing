require 'blazing'
require 'blazing/config'

module Blazing
  class Remote

    def initialize(target_name)
      @target = config.find_target(target_name)
      @recipes = @target.recipes
      setup_recipes
    end

    def post_receive
      set_git_dir
      @recipes.delete_if { |recipe| recipe.name == 'rvm' }
      run_recipes
      reset_head!
    end

    def gemfile_present?
      File.exists? 'Gemfile'
    end

    def set_git_dir
      @_env ||= ENV
      @_dir ||= Dir

      # TODO: cleanup!
      # if @_env['GIT_DIR'] == '.'
        @_dir.chdir('.git')
        # @_dir.chdir('..')
        # @_env['GIT_DIR'] = '.git'
      # end
    end

    def reset_head!
      @runner ||= Blazing::Runner.new
      @runner.run 'git reset --hard HEAD'
    end

    def config
      @_config ||= Blazing::Config
      @_config.load
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
        false
      end
    end

    def setup_recipes

      # TODO: For now, recipes can be assigned only in the global
      # namespace of the config. Make it possible for targets to
      # define recipes individually

      @recipes = config.recipes if @recipes.blank?
      Blazing::Recipe.load_builtin_recipes
    end

    def run_recipes
      run_bootstrap_recipes
      @recipes.each do |recipe|
        recipe.run
      end
    end

    def run_bootstrap_recipes
      # @rvm_recipe.run if use_rvm?

      # if gemfile_present?
      #   # TODO: Bundler setup or something ?
      # end
    end
  end

end
