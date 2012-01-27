require 'erb'
require 'grit'
require 'blazing/config'

# TODO: HANDLE NONEXISTENT TARGET

class Blazing::Runner

  include Blazing::Logger

  def initialize(target_name, options)
    prepare_config(target_name, options)
  end

  #
  # Parse config and set up options
  #
  def prepare_config(target_name, options = {})
    @config ||= Blazing::Config.parse(options[:file])
    @targets = []
    if target_name == :all
      @targets << @config.targets
    else
      @targets << (@config.targets.find { |t| t.name.to_s == target_name } || @config.default_target)
    end
  end

  def setup_git_remotes
    repository = Grit::Repo.new(Dir.pwd)
    @config.targets.each do |target|
      info "Adding new remote #{target.name} pointing to #{target.location}"
      repository.config["remote.#{target.name}.url"] = target.location
    end
  end

  def setup
    @targets.each do |target|
      target.setup
      update
    end
  end

  def update
    setup_git_remotes
    @targets.each { |t| t.apply_hook }
  end

  def recipes
    @config.recipes.each { |recipe| recipe.run }
  end

  class << self

    include Blazing::Logger

    #
    # Bootstrap blazing by creating config file
    #
    def init
      info "Creating an example config file in #{Blazing::DEFAULT_CONFIG_LOCATION}"
      info "Customize it to your needs"

      Dir.mkdir 'config' unless File.exists? 'config'
      configuration_file = ERB.new(File.read("#{Blazing::TEMPLATE_ROOT}/config.erb")).result

      File.open(Blazing::DEFAULT_CONFIG_LOCATION,"wb") do |f|
        f.puts configuration_file
      end
    end

    #
    # List available blazing recipes
    #
    def list
      Blazing::Recipe.list.each { |r| puts r.to_s.demodulize.underscore }
    end

  end
end
