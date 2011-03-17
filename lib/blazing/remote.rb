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

        if target.recipes.include? :rvm
          target.recipes.detele_if { |r| r == :rvm }
          Blazing::Recipes.run(:rvm)
        end
        
        if gemfile_present?
          # TODO: Bundler setup or somethign
        end
        
        target.recipes.each do |recipe|
          Blazing::Recipe.run(recipe)
        end
        
        reset_head!
      end

      def post_setup(target_name)

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
