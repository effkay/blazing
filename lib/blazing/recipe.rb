require 'active_support/inflector'

class Blazing::Recipe

  include Blazing::Logger

  attr_reader :options

  def initialize(options = {})
    @options = options
  end

  def run(target_options = {})
    @options.merge! target_options
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

    def load_recipes
      load_recipe_gems(parse_gemfile)
    end

    def parse_gemfile(gemfile = 'Gemfile')
      open(gemfile).grep(/blazing-/).map { |l| l.match(/blazing-(\w+)/)[0] }
    end

    def load_recipe_gems(gems)
      gems.each do |gem|
        gem_lib_path = $:.find { |p| p.include? gem }
        recipes_path = File.join(gem_lib_path, gem, 'recipes')
        recipes = Dir.entries(recipes_path).delete_if { |r| r == '.' || r == '..' }
        recipes.each { |recipe| require File.join(gem, 'recipes', recipe) }
      end
    end

  end
end
