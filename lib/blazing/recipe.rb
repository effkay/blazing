require 'active_support/inflector'
require 'blazing'
# require 'blazing/logger'

module Blazing
  class Recipe


    # TODO: provide hooks for recipe to use bundle exec

    attr_accessor :name, :options

    def initialize(name, options = {})
      @name = name.to_s
      @options = options
      @logger = options[:_logger] ||= Blazing::Logger.new
      @runner = Blazing::Runner.new
    end

    def recipe_class
      # TODO: Unify naming conventions
      # Gem Recipe Naming Convention
      ('Blazing::' + @name.to_s.gsub('_','/').camelize).constantize
    rescue NameError
      begin
        # Builtin Recipe Naming Convention
        ('Blazing::' + (@name.to_s + '_recipe').camelize).constantize
      rescue NameError
        @logger.log :error, "unable to load #{@name} recipe"
        return nil
      end
    end

    def run
     raise 'run method must be implemented in recipe' 
    end

    class << self

      def new_recipe_by_name(name, options = {})
        load_builtin_recipes
        new(name, options).recipe_class.new(name, options)
      end

      def load_builtin_recipes
        dir = File.join(File.dirname(__FILE__), "/recipes")
        $LOAD_PATH.unshift(dir)
        Dir[File.join(dir, "*.rb")].each { |file| load File.basename(file) }
      end

      def load_gem_recipes
        # TODO: I'm sure there is a better way to do this...
        gems = open('Gemfile').grep(/blazing-/).map { |l| l.match(/(blazing-.*)\'\,/)[1] }
        gems.each do |gem|
          gem_lib_path = $:.find { |p| p.include? gem }
          recipes_path = File.join(gem_lib_path, gem, 'recipes')
          recipes = Dir.entries(recipes_path).delete_if { |r| r == '.' || r == '..' }
          debugger
          recipes.each { |recipe| require File.join(gem, 'recipes', recipe) }
        end
      end

      def load_local_recipes
        #TODO: Implement
      end

      #
      # Return the list of available recipes based
      # on class hierarchy
      #
      def list
        descendants = []

        load_builtin_recipes
        load_gem_recipes

        ObjectSpace.each_object(Class) do |k|
          descendants.unshift k if k < self
        end
        descendants.uniq!
        descendants
      end

    end
  end
end
