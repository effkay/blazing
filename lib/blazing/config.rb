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

    def define_target(name, options = {}, &target_definition)
      
    end


    #attr_reader :file, :targets, :default_target, :repository

    #   case
    #     when target && config.targets.find { |t| t.name == target.to_sym }
    #       target
    #     when config.targets.size == 1
    #       config.targets.first
    #     when config.default_target
    #       config.default_target
    #   end
    # end

    # def define_target(name, &block)
    #   @targets << Blazing::Target.new(name, &block)
    # end

    def recipes(&block)
      
    end

  end
end
