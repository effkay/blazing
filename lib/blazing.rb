require_relative 'blazing/config'

module Blazing
  TEMPLATE_ROOT = File.expand_path(File.join(File.dirname(__FILE__), 'blazing/templates'))
  DEFAULT_CONFIG_LOCATION = 'config/blazing.rb'
  TMP_HOOK = '/tmp/post-receive'
end
