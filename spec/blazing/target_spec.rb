require 'spec_helper'
require 'blazing/target'

describe Blazing::Target do
  describe '#name' do
    it 'returns the name of the target' do
      expect(Blazing::Target.new(:sometarget, 'location', blah: 'blah').name).to be :sometarget
    end
  end

  describe '#options' do
    it 'returns the options hash' do
      expect(Blazing::Target.new(:sometarget, 'location', blah: 'blah').options).to be_a Hash
    end
  end

  describe '#path' do
    it 'extracts the path from the location' do
      target = Blazing::Target.new(:sometarget, 'user@host:/path', blah: 'blah')
      expect(target.path).to eq('/path')
    end
  end

  describe '#host' do
    it 'extracts the host from the location' do
      target = Blazing::Target.new(:sometarget, 'user@host:/path', blah: 'blah')
      expect(target.host).to eq('host')
    end

    it 'returns nil when host is not present' do
      target = Blazing::Target.new(:sometarget, '/path', blah: 'blah')
      expect(target.host).to be_nil
    end
  end

  describe '#user' do
    it 'extracts the user from the location' do
      target = Blazing::Target.new(:sometarget, 'user@host:/path', blah: 'blah')
      expect(target.user).to eq('user')
    end

    it 'returns nil user is not present' do
      target = Blazing::Target.new(:sometarget, '/path', blah: 'blah')
      expect(target.user).to be_nil
    end
  end
end
