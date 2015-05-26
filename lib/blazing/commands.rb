require 'erb'
require 'blazing'
require 'blazing/logger'

module Blazing
  class Commands
    include Logger

    class << self
      def run(command, options = {})
        new(options.merge(command: command)).send(command)
      end
    end

    def initialize(options = {})
      warn 'The :default Target option has been deprecated and will be ignored' if options.key?(:default)
      @cli_options = options[:cli_options]
      @target_name = options[:target_name]
      @config_file = options[:file]
      @command = options[:command]
      @targets = []

      return unless command_requires_config?

      @config ||= Config.parse(@config_file)
      @targets = determine_targets
      error 'no target given or found' if @targets.empty?
    end

    def init
      info "Creating an example config file in #{Blazing::DEFAULT_CONFIG_LOCATION}"
      info 'Customize it to your needs'
      create_config_directory
      write_config_file
    end

    def setup
      @targets.each(&:setup)
      update
    end

    def update
      @targets.each(&:update)
    end

    def goto
      # TODO: Would be nice to detect zsh and use it instead of bash?
      @targets.each do |target|
        if @cli_options[:run]
          system "ssh -t -t #{target.user}@#{target.host} 'cd #{target.path} && RAILS_ENV=#{target.options[:rails_env]} bash --login -c \"#{@cli_options[:run]}\"'"
        else
          system "ssh -t -t #{target.user}@#{target.host} 'cd #{target.path} && RAILS_ENV=#{target.options[:rails_env]} bash --login'"
        end
      end
    end

    private

    def create_config_directory
      Dir.mkdir 'config' unless File.exist? 'config'
    end

    def write_config_file
      config = ERB.new(File.read("#{Blazing::TEMPLATE_ROOT}/config.erb")).result
      File.open(Blazing::DEFAULT_CONFIG_LOCATION, 'wb') { |f| f.puts config }
    end

    def determine_targets
      if @target_name == 'all'
        @config.targets
      else
        targets = []
        targets << @config.target(@target_name)
        targets.compact
      end
    end

    def command_requires_config?
      [:setup, :update, :goto].include? @command
    end
  end
end
