require 'blazing/recipe'

module Blazing

  class BundlerRecipe < Blazing::Recipe

    def initialize(name, options = {})
      options[:flags] ||= '--deployment'
      super(name, options)
    end

    def run
      if File.exists?(File.join(Dir.pwd, 'Gemfile'))
        @runner.run "bundle install #{@options[:flags]}"
      else
        false
      end
    end

  end
end
