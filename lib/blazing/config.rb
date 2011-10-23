require 'blazing/target'
require 'blazing/recipe'

class Blazing::Config

  attr_reader :file
  attr_accessor :targets

  DEFAULT_CONFIG_LOCATION = 'config/blazing.rb'

  def initialize(configuration_file = nil)
    @file = configuration_file || DEFAULT_CONFIG_LOCATION
    @targets = []
    @recipes = []
  end

  def target(name, options = {})
    raise "Name already taken" if targets.find { |t| t.name == name }
    targets << Blazing::Target.new(name, options)
  end

  def repository(location = nil)
    if location
      @repository = location
    else
      @repository
    end
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

  def rake(task = nil)
    if task
      @rake = task
    else
      @rake
    end
  end

  def rvm(rvm_string = nil)
    if rvm_string
      @rvm = rvm_string
    else
      @rvm
    end
  end

  class << self

    def parse(configuration_file = nil)
      config = self.new(configuration_file)
      config.instance_eval(File.read(config.file))

      config
    end

  end

end
