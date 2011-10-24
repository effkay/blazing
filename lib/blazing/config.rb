require 'blazing/target'
require 'blazing/recipe'
require 'blazing/dsl_setter'

class Blazing::Config

  extend Blazing::DSLSetter

  attr_reader :file
  attr_accessor :targets, :recipes
  dsl_setter :repository, :rvm, :rake

  class << self

    def parse(configuration_file = nil)
      Blazing::Recipe.load_gem_recipes
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

  def recipe(name, options = {})
    @recipes << Blazing::Recipe.init_by_name(name, options)
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
