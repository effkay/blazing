require 'spec_helper'

module Blazing

  describe Hook do

    describe '#rake_command' do
      it 'prepends the environment variables specified in the rake call' do
        pending
      end

      it 'appends the RAILS_ENV specified as :rails_env option to the target call' do
        pending
      end

      it 'returns nil when no rake task was specified in config' do
        pending
      end
    end
  end
end
