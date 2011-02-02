module Blazing
  class Remote

    # TODO: Bundler
    # TODO: Check if post-hook and blazing versions match

    class << self

      def post_receive(target_name)
        set_git_dir
        target = config.find_target(target_name)

        if target.recipes.blank?
          target.recipes = config.recipes
        end
        
        # TODO: bundle install should be done before any other recipe
        # TODO: provide hooks for recipe to use bundle exec
        # TODO: run recipes

        reset_head!
      end

      def post_setup(target_name)

      end

      private

      def set_git_dir
        if ENV['GIT_DIR'] == '.'
          Dir.chdir('..')
          ENV['GIT_DIR'] = '.git'
        end
      end

      def reset_head!
        system 'git reset --hard HEAD'
      end

      def config 
        Blazing::Config.load
      end

    end

  end
end
