require 'thor/group'
require 'blazing/remote'

class Blazing::Config

  attr_accessor :targets, :file

  def initialize
    @targets = []
    @file = File.open('config/blazing.rb')
  end

  def self.read(&block)
    config = Blazing::Config.new
    block.arity < 1 ? config.instance_eval(&block) : block.call(config)
    config.instance_eval(&block)
    return config
  end

  def remote(name, &block)
    @targets << Blazing::Target.new(name, @repository, &block)
  end
  
  def repository(url)
    @repository = url
  end

  def determine_target
    target = case
             when self.targets.size == 1 && !self.targets.first.location.nil?
               self.targets.first

             when !self.default.default_target.nil?
               self.targets.find { |t| t.name == self.default.default_target }

             when self.default && !self.default.hostname.nil?
               self.default
             end

    return target
  end

  def default 
    self.targets.find { |t| t.name == :blazing}
  end
  
  # TODO: Why does thor break when this is put into an external file config folder?
  class Create < Thor::Group

    desc 'creates a blazing config file'

    include Thor::Actions

    argument :username
    argument :hostname
    argument :path
    argument :repository

    def self.source_root
      File.dirname(__FILE__)
    end

    def create_blazing_dir
      empty_directory 'config'
    end

    def create_config_file
      template('templates/blazing.tt', "config/blazing.rb")
    end

  end

end
