module Blazing::DSLSetter

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
