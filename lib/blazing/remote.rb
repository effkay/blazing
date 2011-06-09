require 'blazing'
require 'blazing/config'

module Blazing
  class Remote

    def initialize(target_name, options = {})
      @config = options[:config] || Blazing::Config.load
      @target = @config.find_target(target_name)
      @recipes = @target.recipes
      setup_recipes
    end

    def post_receive
      set_git_dir
      reset_head!
      @recipes.delete_if { |recipe| recipe.name == 'rvm' }
      run_recipes
    end

    def gemfile_present?
      File.exists? 'Gemfile'
    end

    def set_git_dir
      Dir.chdir('.git')
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
        false
      end
    end

    def setup_recipes

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
