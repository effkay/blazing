require 'active_support/inflector'

module Blazing
  class Recipe

    # TODO: provide hooks for pe to use bundle exec

    attr_accessor :name, :options

    def initialize(name, options = {})
      @name = name.to_s
      @options = options
    end

    def run
      recipe_implementation = ('Blazing::' + (@name.to_s + '_recipe').camelize).constantize
      puts "gonna run #{@name}"
      if recipe_implementation.method_defined?(:run)
        recipe_implementation.run
      else
        raise "Recipe #{@name} run method not defined"
      end
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
        Dir[File.join(dir, "*.rb")].each { |file| require File.basename(file) }
      end

      def load_gem_recipes
        #TODO: Implement
      end

      def load_local_recipes
        #TODO: Implement
      end

      #
      # Output the list of available recipes
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
