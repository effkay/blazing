module Blazing
  TEMPLATE_ROOT = File.expand_path(File.dirname(__FILE__) + File.join('/', 'blazing', 'templates'))
  DEFAULT_CONFIG_LOCATION = 'config/blazing.rb'
  TMP_HOOK = '/tmp/post-receive'
end
