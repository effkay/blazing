require "blazing/logger"

module Blazing

  autoload :CLI, 'blazing/cli'
  autoload :Config, 'blazing/config'
  autoload :DSLSetter, 'blazing/dsl_setter'
  autoload :Recipe, 'blazing/recipe'
  autoload :COmmands, 'blazing/commands'
  autoload :Shell, 'blazing/shell'
  autoload :Target, 'blazing/target'
  autoload :Hook, 'blazing/hook'

  TEMPLATE_ROOT = File.expand_path(File.dirname(__FILE__) + File.join('/', 'blazing', 'templates'))
  DEFAULT_CONFIG_LOCATION = 'config/blazing.rb'
  TMP_HOOK = '/tmp/post-receive'

end
