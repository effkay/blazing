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
    end

    def recipe_class
      ('Blazing::' + (@name.to_s + '_recipe').camelize).constantize
    rescue NameError
      @logger.log :error, "unable to load #{@name} recipe"
      return nil
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
        #TODO: Implement
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

        ObjectSpace.each_object(Class) do |k|
          descendants.unshift k if k < self
        end
        descendants.uniq!
        descendants
      end

      def create(name, options)
        recipe_class(name)
      end
    end
  end
end
