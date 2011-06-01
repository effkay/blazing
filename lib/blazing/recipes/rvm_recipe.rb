require 'blazing/recipe'

module Blazing
  class RvmRecipe < Blazing::Recipe

    def run
      if ENV['MY_RUBY_HOME'] && ENV['MY_RUBY_HOME'].include?('rvm')
        begin
          rvm_path     = File.dirname(File.dirname(ENV['MY_RUBY_HOME']))
          rvm_lib_path = File.join(rvm_path, 'lib')
          $LOAD_PATH.unshift rvm_lib_path
          require 'rvm'
          RVM.use @options[:rvm_string]
        rescue LoadError
          raise "RVM ruby lib is currently unavailable."
        end
      end

      # TODO: ADD LOGGER!
      if $?.exitstatus == 0
        puts 'successfully executed rvm switch trough recipe'
      else
        puts 'ohno!'
      end

    end

  end
end
