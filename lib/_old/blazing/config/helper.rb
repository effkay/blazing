require 'blazing/config'

module Blazing::Config::Helper

  def self.find_target(target=nil)
    config = Blazing::Config.read do |blazing|
      blazing.instance_eval(File.read blazing.file)
    end

    # Check if remote can be found in config file
    if target
      target = config.targets.find { |t| t.name == target.to_sym }
    end

    target = target || config.determine_target
  end

end
