require 'active_support/inflector'

class Blazing::Recipe

  attr_reader :options

  def initialize(options = {})
    @options = options
  end

  class << self

    def init_by_name(name, options = {})
      "Blazing::Recipe::#{name.to_s.camelize}".constantize.new(options)
    end

    def list
      descendants = []
      ObjectSpace.each_object(Class) do |k|
        descendants.unshift k if k < self
      end
      descendants
    end

    def load_gem_recipes
      # TODO: I'm sure there is a better way to do this...
      gems = open('Gemfile').grep(/blazing-/).map { |l| l.match(/(blazing-.*)\'\,/)[1] }
      gems.each do |gem|
        gem_lib_path = $:.find { |p| p.include? gem }
        recipes_path = File.join(gem_lib_path, gem, 'recipes')
        recipes = Dir.entries(recipes_path).delete_if { |r| r == '.' || r == '..' }
        recipes.each { |recipe| require File.join(gem, 'recipes', recipe) }
      end
    end

  end

end
