require 'active_support/inflector'

class Blazing::Recipe

  include Blazing::Logger

  attr_reader :options

  def initialize(options = {})
    @options = options
  end

  def run(target_options = {})
    @options.merge! target_options
  end

  class << self

    def init_by_name(name, options = {})
      "Blazing::Recipe::#{name.to_s.camelize}".constantize.new(options)
    end

    def list
      load_recipes!
      descendants = []
      ObjectSpace.each_object(Class) do |k|
        descendants.unshift k if k < self
      end
      descendants
    end

    def load_recipes!
      gems = $:.select{|p| p.match /blazing-\w+(|-\d\.\d\.\d)\/lib/}.map { |r| r.scan(/blazing-\w+/)[0] }
      gems.each { |gem| require gem }
    end

  end
end
