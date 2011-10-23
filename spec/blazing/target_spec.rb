require 'spec_helper'
require 'blazing/target'

describe Blazing::Target do

  describe '#name' do
    it 'returns the name of the target' do
      Blazing::Target.new(:sometarget, 'location', :blah => 'blah').name.should be :sometarget
    end
  end

  describe '#options' do
    it 'returns the options hash' do
      Blazing::Target.new(:sometarget, 'location', :blah => 'blah').options.should be_a Hash
    end
  end

  describe '#path' do
    it 'extracts the path from the location' do
      target = Blazing::Target.new(:sometarget, 'user@host:/path', :blah => 'blah')
      target.path.should == '/path'
    end
  end

  describe '#host' do
    it 'extracts the host from the location' do
      target = Blazing::Target.new(:sometarget, 'user@host:/path', :blah => 'blah')
      target.host.should == 'host'
    end

    it 'returns nil when host is not present' do
      target = Blazing::Target.new(:sometarget, '/path', :blah => 'blah')
      target.host.should == nil
    end
  end

  describe '#user' do
    it 'extracts the user from the location' do
      target = Blazing::Target.new(:sometarget, 'user@host:/path', :blah => 'blah')
      target.user.should == 'user'
    end

    it 'returns nil user is not present' do
      target = Blazing::Target.new(:sometarget, '/path', :blah => 'blah')
      target.user.should == nil
    end
  end

end
