require 'blazing/dsl'

class Blazing::Config

  include Blazing::Logger

  attr_reader :file
  attr_accessor :targets, :rake_task, :env_script

  def initialize(configuration_file = nil)
    @file = configuration_file || Blazing::DEFAULT_CONFIG_LOCATION
    @targets = []
    @rake_task = nil
    @env_script = nil
  end

  class << self
    def parse(configuration_file = nil)
      config = self.new(configuration_file)
      Blazing::DSL.new(config).instance_eval(File.read(config.file))
      config
    end
  end

  def target(target_name)
    targets.find { |t| t.name.to_s == target_name.to_s }
  end
end
