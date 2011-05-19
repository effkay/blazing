require 'thor'

module Blazing
  module CLI
    class Hook < Thor

      include Thor::Actions

      argument :target

      desc 'generate', 'generate post-receive hook from template'
      def generate
        template('templates/post-hook.tt', '/tmp/post-receive')
      end

      def self.source_root
        File.dirname(__FILE__)
      end

    end
  end
end
