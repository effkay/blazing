require 'spec_helper'
require 'blazing/config'

describe Blazing::Config do

  describe 'initialize' do
    it 'takes the path of the config file as an argument' do
      config = Blazing::Config.new('/some/where/config.rb')
      config.file.should == '/some/where/config.rb'
    end

    it 'takes the default config path if no path is specified' do
      config = Blazing::Config.new
      config.file.should == 'config/blazing.rb'
    end
  end

end
