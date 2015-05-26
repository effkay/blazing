require 'spec_helper'
require 'blazing/shell'

module Blazing
  describe Shell do
    let(:shell) { Shell.new }

    describe '#run' do
      it 'runs the provided command' do
        shell.should_receive(:`)
        shell.run('command')
      end

      it 'raises an exception when the command fails'
    end
  end
end
