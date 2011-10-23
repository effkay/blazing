require 'erb'
require 'methadone'

class Blazing::Runner

  include Methadone::CLILogging

  def initialize(config)
    @config = config
  end

  def exec(command)
    command_method = "#{command.gsub(':', '_')}_command"
    raise "Unknown Command: #{command}" unless self.respond_to? command_method
    self.send command_method
  end

  def init_command
    info("Creating an example config file in #{Blazing::DEFAULT_CONFIG_LOCATION}")
    info("Customize it to your needs")

    Dir.mkdir 'config' unless Dir.exists? 'config'
    configuration_file = ERB.new(File.read("#{Blazing::TEMPLATE_ROOT}/config.erb")).result

    File.open(Blazing::DEFAULT_CONFIG_LOCATION,"wb") do |f|
      f.puts configuration_file
    end
  end

  def setup_local_command
    repository = Grit::Repo.new(Dir.pwd)
    @config.targets.each do |target|
      info("Adding new remote #{target.name} pointing to #{target.location}")
      repository.config["remote.#{target.name}.url"] = target.location
    end
  end

  def setup_remote_command
  end

  def deploy_command
  end

end
