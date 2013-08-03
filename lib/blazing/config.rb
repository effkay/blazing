require 'blazing/target'

class Blazing::Config

  include Blazing::Logger

  attr_reader :file
  attr_accessor :targets

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

  def rake(task_name, env = nil)
    @rake = { :task => task_name }
    @rake[:env] = env if env
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
    warn "rvm_scripts in config has been deprecated and no longer works. Use env_scripts!"
  end

  def env_scripts(value = nil)
    if value
      instance_variable_set("@env_scripts", value)
    else
      instance_variable_get("@env_scripts")
    end
  end

  def source_rvmrc
    @legacy_rvm = true
  end

  def rvm?
    @legacy_rvm ||= false
  end
end
