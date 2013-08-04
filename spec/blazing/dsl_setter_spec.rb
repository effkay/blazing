require 'spec_helper'
require 'blazing/dsl_setter'

module Blazing

  describe DSLSetter do

    let(:dummy) { class Dummy; extend DSLSetter; end }
    let(:dummy_instance) { Dummy.new }

    it 'it defines a dsl method named after each argument provided' do
      dummy.dsl_setter(:foo, :bar)
      dummy_instance.should respond_to :foo
      dummy_instance.should respond_to :bar
    end

    context 'the generated dsl method' do
      it 'sets an instance variable when provided with an argumnent' do
        dummy_instance.foo('something')
        dummy_instance.instance_variable_get(:@foo).should == 'something'
      end

      it 'returns the value of the istance variable when no argument is provided' do
        dummy_instance.instance_variable_set(:@foo, 'something')
        dummy_instance.foo.should == 'something'
      end
    end
  end
end

