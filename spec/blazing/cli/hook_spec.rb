require 'spec_helper'
require 'blazing/cli/hook'

describe Blazing::CLI::Hook do

  it 'knows the source root for its tempate' do
    Blazing::CLI::Hook.source_root.should == File.dirname(__FILE__).gsub('spec', 'lib')
  end

  it 'it genereates the hook template in the correct location' do
    @hook = Blazing::CLI::Hook.new(['test_target'])
    @hook.should_receive(:template).with('templates/post-hook.tt', '/tmp/post-receive')
    @hook.generate
  end

end
