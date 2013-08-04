require 'blazing/target'

class Blazing::Config

  include Blazing::Logger

  attr_reader :file
  attr_accessor :targets, :rake_task

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
  end

  def target(name, location, options = {})
    raise "Name already taken" if targets.find { |t| t.name == name }
    targets << Blazing::Target.new(name, location, self, options)
  end

  def rake(task_name)
    @rake_task = task_name
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

  def rvm_scripts(value = nil)
    warn "rvm_scripts in config has been deprecated and no longer works. Use env_script!"
  end

  def env_script(value = nil)
    if value
      instance_variable_set("@env_script", value)
    else
      instance_variable_get("@env_script")
    end
  end
end
