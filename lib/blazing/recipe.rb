require 'active_support/inflector'

class Blazing::Recipe

  attr_reader :options

  def initialize(options = {})
    @options = options
  end

  class << self

    def init_by_name(name, options = {})
      "Blazing::Recipe::#{name.to_s.camelize}".constantize.new(options)
    end

  end

end
