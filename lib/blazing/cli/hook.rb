require 'thor'

module Blazing
  module CLI
    class Hook < Thor

      include Thor::Actions

      def self.source_root
        File.dirname(__FILE__)
      end

      argument :target

      desc 'generate', 'generate post-receive hook from template'
      def generate
        template('templates/post-hook.tt', '/tmp/post-receive')
      end

    end
  end
end
