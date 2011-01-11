require 'thor/group'
require 'blazing/target'

class Blazing::Config

  attr_accessor :targets, :file

  def initialize
    @targets = []
    @file = File.open('deploy/blazing.rb')
  end

  def self.read(&block)
    config = Blazing::Config.new
    block.arity < 1 ? config.instance_eval(&block) : block.call(config)
    return config
  end

  def target(name, &block)
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

end
