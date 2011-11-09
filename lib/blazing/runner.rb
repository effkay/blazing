require 'erb'
require 'grit'

class Blazing::Runner

  include Blazing::Logger

  def initialize(config = nil, target = nil)
    if config
      @config = config
      @target = @config.targets.find { |t| t.name.to_s == target } || @config.default_target
    end
  end

  def exec(command)
    command_method = "#{command.gsub(':', '_')}_command"
    raise "Unknown Command: #{command}" unless self.respond_to? command_method
    self.send command_method
  end

  def init_command
    info "Creating an example config file in #{Blazing::DEFAULT_CONFIG_LOCATION}"
    info "Customize it to your needs"

    Dir.mkdir 'config' unless File.exists? 'config'
    configuration_file = ERB.new(File.read("#{Blazing::TEMPLATE_ROOT}/config.erb")).result

    File.open(Blazing::DEFAULT_CONFIG_LOCATION,"wb") do |f|
      f.puts configuration_file
    end
  end

  def setup_git_remotes
    repository = Grit::Repo.new(Dir.pwd)
    @config.targets.each do |target|
      info "Adding new remote #{target.name} pointing to #{target.location}"
      repository.config["remote.#{target.name}.url"] = target.location
    end
  end

  def setup_command
    @target.setup
    update_command
  end

  def update_command
    setup_git_remotes
    @target.apply_hook
  end

  def recipes_run_command
    @config.recipes.each { |recipe| recipe.run(@target.options) }
  end

  def recipes_list_command
    Blazing::Recipe.list.each { |r| puts r.to_s.demodulize.underscore }
  end

end
