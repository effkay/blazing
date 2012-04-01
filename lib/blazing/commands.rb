module Blazing
  class Commands

    include Logger

    class << self
      def run(command, options = {})
        self.new(options).send(command)
      end
    end

    def initialize(options = {})
      warn 'The :default Target option has been deprecated and will be ignored' if options.has_key?(:default)

      @target_name = options[:target_name]
      @config_file = options[:file]

      @config ||= Config.parse(@config_file)
      @targets = determine_targets

      error 'no target given or found' if @targets.empty?

      # TODO: better exception handling, like this?
      #raise RuntimeError if @targets.empty?
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
      @config.recipes.each { |recipe| recipe.run }
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
  end
end
