module Blazing
  class remote

    # TODO: RVM
    # TODO: Bundler
    # TODO: Check if post-hook and blazing versions match

    class << self

      def post_receive(target)
        set_git_dir
        reset_head
      end

    end

    def set_git_dir
      if ENV['GIT_DIR'] == '.'
        Dir.chdir('..')
        ENV['GIT_DIR'] = '.git'
      end
    end

    def reset_head
      system 'git reset --hard HEAD'
    end

  end
end

# if ENV['MY_RUBY_HOME'] && ENV['MY_RUBY_HOME'].include?('rvm')
#   begin
#     rvm_path     = File.dirname(File.dirname(ENV['MY_RUBY_HOME']))
#     rvm_lib_path = File.join(rvm_path, 'lib')
#     $LOAD_PATH.unshift rvm_lib_path
#     require 'rvm'
#     RVM.use_from_path! File.dirname(File.dirname(__FILE__))
#   rescue LoadError
#     # RVM is unavailable at this point.
#     raise "RVM ruby lib is currently unavailable."
#   end
# end

