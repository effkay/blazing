require 'blazing/logger'
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

  private

  def sudo
    options[:sudo] || 'sudo'
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
    rescue LoadError
      # Here because using blazing from git now produces a match like 'blazing-269ee17d65d1'
    end

    def pretty_list
      list.each { |r| puts r.to_s.demodulize.underscore }
    end

  end
end
