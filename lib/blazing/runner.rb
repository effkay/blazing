require 'erb'
require 'methadone'
require 'blazing/command/init'
require 'blazing/command/setup'
require 'blazing/command/deploy'

class Blazing::Runner

  include Methadone::CLILogging

  include Blazing::Command::Init
  include Blazing::Command::Setup
  include Blazing::Command::Deploy

  def initialize(config = nil, target = nil)
    if config
      @config = config
      @target = @config.targets.find { |t| t.name == target.to_s } || @config.default_target
    end
  end

  def exec(command)
    command_method = "#{command.gsub(':', '_')}_command"
    raise "Unknown Command: #{command}" unless self.respond_to? command_method
    self.send command_method
  end

end
