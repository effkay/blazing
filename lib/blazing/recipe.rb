require 'active_support/inflector'

class Blazing::Recipe

  class << self

    def init_by_name(name)
      "Blazing::Recipe::#{name.to_s.camelize}".constantize.new
    end

  end

end
