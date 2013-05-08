require 'erb'

module Blazing
  class Commands

    include Logger

    class << self
      def run(command, options = {})
        self.new(options.merge({ :command => command })).send(command)
      end
    end

    def initialize(options = {})
      warn 'The :default Target option has been deprecated and will be ignored' if options.has_key?(:default)
      @cli_options = options[:options] # that stinks! TODO: clean up options handling.
      @target_name = options[:target_name]
      @config_file = options[:file]
      @command = options[:command]
      @targets = []

      if command_requires_config?
        @config ||= Config.parse(@config_file)
        @targets = determine_targets
        error 'no target given or found' if @targets.empty?
      end
    end

    def init
      info "Creating an example config file in #{Blazing::DEFAULT_CONFIG_LOCATION}"
      info "Customize it to your needs"
      create_config_directory
      write_config_file
    end

    def setup
      @targets.each { |target| target.setup }
      update
    end

    def update
      @targets.each { |target| target.update }
    end

    def recipes
      @config.recipes.each { |recipe| recipe.run({:target_name => @target_name}) }
    end

    def goto
      # TODO: Would be nice to detect zsh and use it instead of bash?
      @targets.each do |target|
        if @cli_options[:run]
          system "ssh -t #{target.user}@#{target.host} 'cd #{target.path} && RAILS_ENV=#{target.options[:rails_env]} bash --login -c \"#{@cli_options[:run]}\"'"
        else
          system "ssh -t #{target.user}@#{target.host} 'cd #{target.path} && RAILS_ENV=#{target.options[:rails_env]} bash --login'"
        end
      end
    end

    def list
      Blazing::Recipe.pretty_list
    end

    private

    def create_config_directory
      Dir.mkdir 'config' unless File.exists? 'config'
    end

    def write_config_file
      config = ERB.new(File.read("#{Blazing::TEMPLATE_ROOT}/config.erb")).result
      File.open(Blazing::DEFAULT_CONFIG_LOCATION,"wb") { |f| f.puts config }
    end

    def determine_targets
      if @target_name == 'all'
        @config.targets
      else
        targets = []
        targets << @config.find_target(@target_name)
        targets.compact
      end
    end

    def command_requires_config?
      [:setup, :update, :recipes, :goto].include? @command
    end
  end
end

