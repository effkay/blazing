module Blazing
  class Remote
    class << self

      def post_receive(target_name)
        set_git_dir
        target = config.find_target(target_name)

        # TODO: Check if post-hook and blazing versions match before doing anything

        if target.recipes.blank?
          target.recipes = config.recipes
        end

        # TODO: looks stupid. shorter way to do it?
        use_rvm = target.recipes.find { |recipe| recipe.name == 'rvm' }
        target.recipes.delete_if { |recipe| recipe.name == 'rvm' }

        if use_rvm
          use_rvm.run
        end

        if gemfile_present?
          # TODO: Bundler setup or something
        end

        target.recipes.each do |recipe|
          recipe.run
        end

        reset_head!
      end

      def post_setup(target_name)
        # TODO: needed?
      end

      private

      def gemfile_present?
        File.exists? 'Gemfile'
      end

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
