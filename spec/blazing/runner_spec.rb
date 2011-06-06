require 'spec_helper'

describe Blazing::Runner do
  describe '#run' do
    it 'delegates run to Kernel#system' do
      @command = 'ls'
      @runner = Blazing::Runner.new
      @runner.should_receive(:system).with(@command)
      @runner.run(@command)
    end
  end
end
