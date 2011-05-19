require 'blazing/recipe'

module Blazing

  class RvmRecipe < Blazing::Recipe

    def self.run
      puts 'buhuuuuuu, running rvm!'
      success
    end

    def self.success
      puts 'yay, ran rvm successfully!!!!!!'
    end
  end

end
