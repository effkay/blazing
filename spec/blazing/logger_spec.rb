require 'spec_helper'
require 'blazing/logger'
require 'blazing/object'

describe Blazing::Logger do
  before :each do
    class Dummy
      include Blazing::Logger
    end
    @dummy = Dummy.new
  end

  context 'message logger' do
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

  context 'message reporter' do
    it 'prints the messages from the messages hash' do
      @dummy.log :info, 'just a message'
      $stdout.should_receive(:puts).with('just a message')
      @dummy.report
    end

    it 'prints all messages when no type given' do
      @dummy.log :info, 'an info message'
      @dummy.log :warn, 'a warn message'
      $stdout.should_receive(:puts).exactly(2).times
      @dummy.report
    end

    it 'prints only the message of the given type when a type is supplied' do
      @dummy.log :info, 'an info message'
      @dummy.log :info, 'another info message'
      @dummy.log :warn, 'a warn message'
      $stdout.should_receive(:puts).exactly(2).times
      @dummy.report(:info)
    end
  end
end
