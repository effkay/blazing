require 'spec_helper'
require 'blazing'
require 'blazing/cli/base'

describe 'CLI invocation' do
  context 'without options' do
    it 'should raise no errors' do
      silence(:stderr) { lambda { Blazing::CLI::Base.start }.should_not raise_error }
    end
  end
end
