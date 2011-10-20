class Blazing::Config

  attr_reader :file

  DEFAULT_CONFIG_LOCATION = 'config/blazing.rb'

  def initialize(configuration_file = nil)
    @file = configuration_file || DEFAULT_CONFIG_LOCATION
  end

  class << self

    def parse(configuration_file = nil)
      config = self.new(configuration_file)
      config.instance_eval(File.read(config.file))

      config
    end

  end

end
