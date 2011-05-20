require 'blazing'
require 'blazing/object'

module Blazing
  class Target

    attr_accessor :name, :recipes

    AVAILABLE_SETTINGS = [:deploy_to, :host, :user, :path, :default]

    def initialize(name, options = {})
      @name = name.to_s
      @logger = options[:_logger] ||= Blazing::Logger.new
      @runner = options[:_runner] ||= Blazing::Runner
      create_accesors(options)
    end

    def setup
      clone_repository
      add_target_as_remote
      setup_post_receive_hook
    end

    def deploy
      @runner.run "git push #{name}"
    end

    def config
      @_config ||= Blazing::Config
      @_config.load
    end

    def create_accesors(options)
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

    #TODO: to be specced, from here on down...

    def clone_command
      "if [ -e #{@path} ]; then \
      echo 'directory exists already'; else \
      git clone #{config.repository} #{@path} && cd #{@path} && git config receive.denyCurrentBranch ignore; fi"
    end

    def clone_repository
      @runner.run "ssh #{@user}@#{@host} '#{clone_command}'"
    end

    def add_target_as_remote
      @runner.run "git remote add #{@name} #{@user}@#{@host}:#{@path}"
    end

    def setup_post_receive_hook
      Blazing::CLI::Hook.new([@name]).generate
      @runner.run "scp /tmp/post-receive #{@user}@#{@host}:#{@path}/.git/hooks/post-receive"
      @runner.run "ssh #{@user}@#{@host} 'chmod +x #{@path}/.git/hooks/post-receive'"
    end

  end
end
