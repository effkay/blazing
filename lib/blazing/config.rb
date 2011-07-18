require 'blazing'
require 'blazing/target'

module Blazing
  class Config

    class << self

      #
      # Read the Configuration File
      #
      def read(&block)
        config = Blazing::Config.new
        config.instance_eval(&block)

        config
      end

      #
      # Load configuration file and parse it
      #
      def parse
        read do
          instance_eval(File.read(Blazing::CONFIGURATION_FILE))
        end
      end

      #
      # DSL Setter helper method
      #
      def dsl_setter(*names)
        names.each do |name|
          class_eval <<-EVAL
            def #{name}(value = nil)
              if value
                instance_variable_set("@#{name}", value)
              else
                instance_variable_get("@#{name}")
              end
            end
          EVAL
        end
      end

    end

    dsl_setter :repository
    attr_accessor :targets, :recipes

    def initialize
      @targets = []
      @recipes = []
    end

    def target(name, options = {})
      @targets << Blazing::Target.new(name, options.merge(:config => self))
    end

    def use(name, options = {})
      @recipes << Blazing::Recipe.new_recipe_by_name(name, options)
    end

    #
    # Determines which target is picked, based on defaults and CLI argument
    # If only one target is defined, it is the default one
    #
    def find_target(target_name = nil)
      active_target = nil

      if target_name
        active_target = targets.find {|target| target.name == target_name }
      end

      if active_target.nil? && targets.size == 1
        active_target = targets.first
      end

      if active_target.nil?
        active_target = targets.find {|target| target.default }
      end

      if active_target.nil?
        raise 'no target specified and no default targets found'
      end

      active_target
    end

  end
end
