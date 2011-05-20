require 'thor'
require 'thor/group'
require 'blazing'
require 'blazing/config'
require 'blazing/runner'
require 'blazing/logger'
require 'blazing/target'
require 'blazing/remote'
require 'blazing/recipe'
require 'blazing/object'
require 'blazing/cli/base'
require 'blazing/cli/create'
require 'blazing/cli/hook'

module Blazing

  DIRECTORY = 'config'
  CONFIGURATION_FILE = 'config/blazing.rb'

  def self.log(*args)
    @logger ||= Blazing::Logger.new
    @logger.log(*args)
  end

  def self.report(type = nil)
    @logger.report(type)
  end

end
