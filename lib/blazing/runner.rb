require 'erb'
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

    if target_name == 'all'
      @targets = @config.targets
    else
      @targets  << (@config.targets.find { |t| t.name.to_s == target_name.to_s } || @config.default_target)
    end

    @targets.compact!

    error 'no target given or found' if @targets.empty?
  end

  def setup
    return if @targets.empty?

    @targets.each do |target|
      target.setup
    end
    update
  end

  def update
    return if @targets.empty?

    @targets.each do |t|
      t.setup_git_remote
      t.apply_hook
    end
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
