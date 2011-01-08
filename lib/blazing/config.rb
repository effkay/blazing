require 'thor/group'

class Blazing::Config

  attr_accessor :targets, :file

  def initialize
    @targets = []
    @file = File.open('deploy/blazing.rb')
  end

  def self.read(&block)
    config = Blazing::Config.new

    p config

    block.arity < 1 ? config.instance_eval(&block) : block.call(config)
    

    p config

    return config
  end

  def target(name)
    @targets << name
    p "asdasd #{@targets}"
  end

  class Create < Thor::Group

    include Thor::Actions

    argument :username
    argument :hostname
    argument :path

    def self.source_root
      File.dirname(__FILE__)
    end

    def create_blazing_dir
      empty_directory 'deploy'
    end

    def create_config_file
      template('templates/blazing.tt', "deploy/blazing.rb")
    end

  end

end
