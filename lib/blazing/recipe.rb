module Blazing
  class Recipe

    # TODO: provide hooks for recipe to use bundle exec
    # TODO: check if i use active_support syntacitc sugar like constantize etc, wrap into
    #       own and shorter code

    attr_accessor :name, :options

    class << self
      
      def run(name, options = {})
        @name = name.to_s
        @options = options
        
        # TODO: LOAD ALL RECIPES FROM THE TWO LOCATIONS
        #       THEN CHECK IF I HAVE THEM OR NOT
        # http://stackoverflow.com/questions/735073/best-way-to-require-all-files-from-a-directory-in-ruby
        
        
        # TODO: fix paths
        # TODO: how can i have multipe requires?
        begin
          require File.join( __FILE__ + 'recipes' + @name )
        rescue LoadError
          require 'try to load the file from lib/recipes'
        end
        
        # TODO: Fail if i could not load recipe
        
        recipe = @name.to_s.camelize.constantize
        if recipe.responds_to(:run)
          recipe.run
        else
          # TODO: Raise? Or just show an error?
          raise 'recipe does not have a run method'
        end
      end
    
    end
    
    def fail
      raise 'NOT IMPLEMENTED'
      # TODO: implement meaningful default behaviour!
    end

    def success
      raise 'NOT IMPLEMENTED'
      # TODO: implement meaningful default behaviour!
    end

  end
end