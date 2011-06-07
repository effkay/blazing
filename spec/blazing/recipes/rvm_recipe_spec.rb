require 'spec_helper'
require 'blazing/recipes/rvm_recipe'

describe Blazing::RvmRecipe do

  describe '#run' do
    it 'returns false, as the recipe itself is handled in shellscript' do
      Blazing::RvmRecipe.new('rvm_recipe').run.should be false
    end
  end
end
