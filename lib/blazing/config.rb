require 'blazing/target'
require 'blazing/recipe'
require 'blazing/dsl_setter'

class Blazing::Config

  extend Blazing::DSLSetter

  attr_reader :file
  attr_accessor :targets
  dsl_setter :repository, :rvm, :rake

  class << self

    def parse(configuration_file = nil)
      config = self.new(configuration_file)
      config.instance_eval(File.read(config.file))

      config
    end

  end

  def initialize(configuration_file = nil)
    @file = configuration_file || Blazing::DEFAULT_CONFIG_LOCATION
    @targets = []
    @recipes = []
  end

  def target(name, location, options = {})
    raise "Name already taken" if targets.find { |t| t.name == name }
    targets << Blazing::Target.new(name, location, self, options)
  end

  def recipes(recipes = nil)
    if recipes.kind_of? Symbol
      @recipes << Blazing::Recipe.init_by_name(recipes)
    elsif recipes.kind_of? Array
      @recipes = recipes.map { |r| Blazing::Recipe.init_by_name(r) }
    else
      @recipes
    end
  end

  def default_target
    if @targets.size > 1
      default = @targets.find { |t| t.options[:default] == true }
      raise 'could not find default target' unless default
      default
    else
      @targets.first
    end
  end

end
