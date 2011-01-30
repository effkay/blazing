module Blazing
  class Recipe

    attr_accessor :name, :options

    def initialize(name, options = {})
      @name = name.to_s
      @options = options
    end

  end
end

# TODO: recipes as gems: blazing_hoptoad, blazing_rpm etc.
# TODO: provide setup, run and use methods and ability to override the whole recipe
# TODO: Must be callable from global namespace and from remote block

# TODO:  make it easy to keep recipe externally and use git submodule
#
# TODO:  later, make it possible to keep recipe and setup of all projects in
#    a central repo:
#
#    /recipes
#    /projects/
#      "   "   someproject.rb
#      "   "   anotherpoject.rb
#
#
#      ????

