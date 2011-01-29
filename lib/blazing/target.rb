# TODO: Try to read username/hostname for ssh from git url, else raise error
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

  end
end
