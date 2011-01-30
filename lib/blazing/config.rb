module Blazing
  class Config

    class << self
      
      #
      # Read the Configuration File
      #
      def read(&block)
        config = Blazing::Config.new
        config.instance_eval(&block)
        return config
      end

      #
      # Load configuration file and parse it
      #
      def load
        # TODO: shorten with something like this: new.instance_eval(File.read(guardfile_path), guardfile_path, 1)
        config = self.read do
          instance_eval(File.read Blazing::CONFIGURATION_FILE)
        end
      end

      #
      # DSL Setter helper method
      #
      def dsl_setter(*names)
        names.each do |name|
          define_method name do |value = nil|
            if value
              instance_variable_set("@#{name}", value)
            else
              instance_variable_get("@#{name}")
            end
          end
        end
      end

    end

    dsl_setter :repository
    attr_accessor :targets, :recipes

    def initialize
      @targets = []
      @recipes = []
    end

    def target(name, options = {}, &target_definition)
      # TODO: implement if needed: target_definition.call if target_definition
      @targets << Blazing::Target.new(name, options)
    end

    def use(name, options = {}, &recipe_definition)
      #TODO: implement if needed: recipe_definition.call if recipe_definition
      @recipes << Blazing::Recipe.new(name, options)
    end

    #
    # Determines which target is picked, based on defaults and CLI argument
    # If only one target is defined, it is the default one
    #
    def find_target(target_name)
      if target_name
        target = targets.find {|target| target.name == target_name }
      end

      if target.nil? && targets.size == 1
        target = targets.first
      end

      if target.nil?
        target = targets.find {|target| target.default }
      end

      if target.nil?
        raise 'no target specified and no default targets found'
      end

      target
    end

  end
end
