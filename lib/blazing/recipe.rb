module Blazing
  class Recipe

    attr_accessor :name, :options

    def initialize(name, options = {})
      @name = name.to_s
      @options = options
    end

    def execute
      # TODO: load and run the actual recipe 
    end

  end
end
