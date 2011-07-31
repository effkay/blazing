module Blazing
  class Target
    module Bootstrap

      def clone_command
        "if [ -e #{@path} ]; then \
        echo 'directory exists already'; else \
        git clone #{@repository} #{"--branch #{@branch}" if @branch} #{@path} && cd #{@path} && git config receive.denyCurrentBranch ignore; fi"
      end

      def clone_repository
        @runner.run "ssh #{@user}@#{@host} '#{clone_command}'"
      end

      def add_target_as_remote
        @runner.run "git remote add #{@name} #{@user}@#{@host}:#{@path}"
      end

      def setup_post_receive_hook
        @hook.new([@name, use_rvm?]).generate
        @runner.run "scp /tmp/post-receive #{@user}@#{@host}:#{@path}/.git/hooks/post-receive"
        @runner.run "ssh #{@user}@#{@host} 'chmod +x #{@path}/.git/hooks/post-receive'"
      end

    end
  end
end
