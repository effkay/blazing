module Blazing

  class BundlerRecipe < Blazing::Recipe
    def self.run
      puts 'buhuuuuuu, running bundler!'
      success
    end

    def self.success
      puts 'yay, ran Bundler successfully!!!!!!'
    end
  end

end
