require 'blazing/target'
require 'blazing/recipe'
require 'blazing/dsl_setter'

class Blazing::Config

  extend Blazing::DSLSetter
  include Blazing::Logger

  attr_reader :file
  attr_accessor :targets, :recipes
  dsl_setter :rvm, :rvm_scripts

  class << self
    def parse(configuration_file = nil)
      Blazing::Recipe.load_recipes!
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

  def rake(task_name, env = nil)
    @rake = { :task => task_name }
    @rake[:env] = env if env
  end

  def repository(*args)
    warn 'Ther repository DSL method has been deprecated and is no longer used. This method will be removed in Version 0.3'
  end

  def default_target
    if @targets.size == 1
      @targets.first
    end
  end

  # TODO: Spec it!
  def find_target(target_name)
    targets.find { |t| t.name.to_s == target_name.to_s }
  end

end
