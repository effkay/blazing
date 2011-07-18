require 'blazing'
require 'blazing/object'

module Blazing
  class Target

    attr_accessor :name, :recipes

    AVAILABLE_SETTINGS = [:deploy_to, :host, :user, :path, :default, :branch]

    def initialize(name, options = {})
      @name = name.to_s
      @logger = options[:_logger] ||= Blazing::Logger.new
      @runner = options[:_runner] ||= Blazing::Runner.new
      @hook = options[:_hook] ||= Blazing::CLI::Hook
      create_accessors(options)
    end

    def setup
      # TODO: Use a Wrapper to Net::SSH
      #
      clone_repository
      checkout_correct_branch if @branch
      add_target_as_remote
      setup_post_receive_hook
    end

    def deploy
      deploy_command = "git push #{name}"
      deploy_command += " #{@branch}:#{@branch}" if @branch
      @runner.run deploy_command
    end

    def config
      @_config ||= Blazing::Config
      @_config.load
    end

    def create_accessors(options)
      assign_settings(options)
      parse_deploy_to_string unless @deploy_to.blank?
      ensure_mandatory_settings
    end

    def assign_settings(options)
      AVAILABLE_SETTINGS.each do |option|
        instance_variable_set("@#{option}", options[option])
        self.class.send(:attr_accessor, option)
      end
    end

    # If the :deploy_to option is set, user, host and path are overriden
    def parse_deploy_to_string
      @host = @deploy_to.scan(/@(.*):/).join
      @user = @deploy_to.scan(/(.*)@/).join
      @path = @deploy_to.scan(/:(.*)/).join
    end

    # Raise an error if one of the required options is still empty
    def ensure_mandatory_settings
      [:host, :user, :path].each do |option|
        raise "#{option} can't be blank!" if instance_variable_get("@#{option}").blank?
      end
    end

    def clone_command
      "if [ -e #{@path} ]; then \
      echo 'directory exists already'; else \
      git clone #{config.repository} #{@path} && cd #{@path} && git config receive.denyCurrentBranch ignore; fi"
    end

    def checkout_correct_branch
      @runner.run "ssh #{@user}@#{@host} 'cd #{@path} && git checkout #{@branch}'" if @branch
    end

    def clone_repository
      @runner.run "ssh #{@user}@#{@host} '#{clone_command}'"
    end

    def add_target_as_remote
      @runner.run "git remote add #{@name} #{@user}@#{@host}:#{@path}"
    end

    def setup_post_receive_hook
      @hook.new([Blazing::Remote.new(@name).use_rvm?]).generate
      @runner.run "scp /tmp/post-receive #{@user}@#{@host}:#{@path}/.git/hooks/post-receive"
      @runner.run "ssh #{@user}@#{@host} 'chmod +x #{@path}/.git/hooks/post-receive'"
    end

  end
end
