require 'blazing'
require 'blazing/config'

module Blazing
  class Remote

    # TODO: Check if post-hook and blazing versions match before doing anything

    def post_receive(target_name)
      set_git_dir
      @target = config.find_target(target_name)
      @recipes = @target.recipes
      setup_and_run_recipes
      reset_head!
    end

    def gemfile_present?
      File.exists? 'Gemfile'
    end

    def set_git_dir
      @_env ||= ENV
      @_dir ||= Dir
      if @_env['GIT_DIR'] == '.'
        @_dir.chdir('..')
        @_env['GIT_DIR'] = '.git'
      end
    end

    def reset_head!
      @runner ||= Blazing::Runner.new
      @runner.run 'git reset --hard HEAD'
    end

    def config
      @_config ||= Blazing::Config
      @_config.load
    end

    def use_rvm?
      @rvm_recipe = @recipes.find { |recipe| recipe.name == 'rvm' }
      @recipes.delete_if { |recipe| recipe.name == 'rvm' }

      @rvm_recipe
    end

    def setup_and_run_recipes
      @recipes = config.recipes if @recipes.blank?
      Blazing::Recipe.load_builtin_recipes
      run_recipes
    end

    def run_recipes
      run_bootstrap_recipes
      @recipes.each do |recipe|
        recipe.run
      end
    end

    def run_bootstrap_recipes
      @rvm_recipe.run if use_rvm?

      # if gemfile_present?
      #   # TODO: Bundler setup or something ?
      # end
    end
  end

end
