require 'spec_helper'
require 'blazing/logger'
require 'blazing/core_ext/object'

describe Blazing::Logger do

  before :each do
    @output = double
    @logger = Blazing::Logger.new(@output)
  end

  context 'message logger' do
    it 'saves the message within the logging class' do
      @logger.log :info, 'something'
      @logger.instance_variable_get('@messages').should_not be_blank
    end

    it 'keeps track what log level a message has' do
      @logger.log :info, 'something'
      @logger.instance_variable_get('@messages').first[:type].should be :info
    end

    it 'fails if the log level is unknown' do
      lambda { @logger.log(:meh, 'something') }.should raise_error
    end
  end

  context 'message reporter' do
    it 'prints the messages from the messages hash' do
      @logger.log :info, 'just a message'
      @output.should_receive(:puts).with('just a message')
      @logger.report
    end

    it 'prints all messages when no type given' do
      @logger.log :info, 'an info message'
      @logger.log :warn, 'a warn message'
      @output.should_receive(:puts).exactly(2).times
      @logger.report
    end

    it 'prints only the message of the given type when a type is supplied' do
      @logger.log :info, 'an info message'
      @logger.log :info, 'another info message'
      @logger.log :warn, 'a warn message'
      @output.should_receive(:puts).exactly(2).times
      @logger.report(:info)
    end
  end
end
