require 'spec_helper'
require 'blazing/runner'

describe Blazing::Runner do

  before :each do
    @config = double('config')
  end

  describe '#exec' do

    it 'fails if the command does not exist' do
      lambda { Blazing::Runner.new(@config).exec('weird_command') }.should raise_error
    end

  end

end
