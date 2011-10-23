require 'spec_helper'
require 'blazing/runner'
require 'blazing/config'

#
# NOTE: More specs for Runner in the integration directory.
#

describe Blazing::Runner do

  before :each do
    @config = Blazing::Config.new
    @config.target :sometarget, 'somewhere', :default => true
  end

  describe '#exec' do

    it 'fails if the command does not exist' do
      lambda { Blazing::Runner.new(@config).exec('weird_command') }.should raise_error
    end

  end

end
