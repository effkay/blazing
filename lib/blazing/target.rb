module Blazing
  class Target < Config

    attr_accessor :name

    @@configuration_options = [:deploy_to, :host, :user, :path, :default]

    def initialize(name, options = {})
      @name = name.to_s
      @@configuration_options.each do |option|
        instance_variable_set("@#{option}", options[option])
        self.class.send(:attr_accessor, option)
      end

      # If the :deploy_to option is given, user, host and path are overriden
      unless deploy_to.blank? 
        @host = deploy_to.scan(/@(.*):/).join
        @user = deploy_to.scan(/(.*)@/).join
        @path = deploy_to.scan(/:(.*)/).join
      end

      # Raise an error if one of the required options is still empty
      [:host, :user, :path].each do |option|
        raise "#{option} can't be blank!" if instance_variable_get("@#{option}").blank?
      end
    end

    def setup

      # TODO: Log some output?
      # TODO: install post-receive hook and make it executable

      config = Blazing::Config.load
      clone_command = "if [ -e #{path} ]; then \
                     echo 'directory exists already'; else \
                     git clone #{config.repository} #{path} && cd #{path} && git config receive.denyCurrentBranch ignore; fi"

      system "ssh #{user}@#{host} '#{clone_command}'"
      system "git remote add #{name} #{user}@#{host}:#{path}"

      Blazing::CLI::Hook.new([name]).generate #.generate(target.name)
      system "scp /tmp/post-receive #{user}@#{host}:#{path}/.git/hooks/post-receive"
      system "ssh #{user}@#{host} 'chmod +x #{path}/.git/hooks/post-receive'"
    end

    def deploy
      system "git push #{name}"
    end

  end
end
