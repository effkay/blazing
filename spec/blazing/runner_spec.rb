require 'spec_helper'

describe Blazing::Runner do
  it 'delegates run to Kernel#system' do
    @command = 'ls'
    Blazing::Runner.should_receive(:system).with(@command)
    Blazing::Runner.run(@command)
  end
end
