require 'spec_helper'
require 'blazing/logger'

describe Blazing::Logger do
  before :each do
    class Dummy
      include Blazing::Logger
    end
    @dummy = Dummy.new
  end

  context 'logging a message' do
    it 'saves the message within the logging class' do
      @dummy.log :info, 'something'
      @dummy.instance_variable_get('@messages').should_not be_blank
    end

    it 'keeps track what log level a message has' do
      @dummy.log :info, 'something'
      @dummy.instance_variable_get('@messages').first[:type].should be :info
    end

    it 'fails if the log level is unknown' do
      lambda { @dummy.log(:meh, 'something') }.should raise_error
    end
  end
end
