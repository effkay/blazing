require 'spec_helper'

module Blazing
  describe Logger do
    let(:logger) { Logger.new }
    let(:dummy) { class Dummy; include Logger; end }

    context 'defines convenience methods' do
      it 'for debug messages' do
        dummy.respond_to? :debug
      end

      it 'for info messages' do
        dummy.respond_to? :info
      end

      it 'for warn messages' do
        dummy.respond_to? :warn
      end

      it 'for error messages' do
        dummy.respond_to? :error
      end

      it 'for fatal messages' do
        dummy.respond_to? :fatal
      end
    end
  end
end
