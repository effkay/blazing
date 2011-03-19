require 'active_support/inflector'

module Blazing
  class Recipe

    # TODO: provide hooks for recipe to use bundle exec

    attr_accessor :name, :options

    def initialize(name, options = {})
      @name = name.to_s
      @options = options
    end

    def run
      recipe_class.run
    end

    def recipe_class
      ('Blazing::' + (@name.to_s + '_recipe').camelize).constantize
    end

    def fail
      raise 'NOT IMPLEMENTED'
      # TODO: implement meaningful default behaviour!
    end

    def success
      raise 'NOT IMPLEMENTED'
      # TODO: implement meaningful default behaviour!
    end

    class << self

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
        load_builtin_recipes

        descendants = []
        ObjectSpace.each_object(Class) do |k|
          descendants.unshift k if k < self
        end
        descendants.uniq!
        descendants
      end

    end

  end
end
