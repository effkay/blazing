# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'blazing/version'

Gem::Specification.new do |s|
  s.name        = 'blazing'
  s.version     =  ::Blazing::VERSION
  s.authors     = ['Felipe Kaufmann', 'Alexander Adam']
  s.email       = ['felipekaufmann@gmail.com']
  s.homepage    = 'https://github.com/effkay/blazing'
  s.summary     = 'git push deployment helper'
  s.description = 'painless git push deployments for everyone'
  s.rubyforge_project = 'blazing'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_path  = 'lib'
  s.required_ruby_version = '>= 2.0.0'

  s.add_development_dependency('rdoc')
  s.add_development_dependency('rake', '~> 0.9.2')
  s.add_development_dependency('rspec', '>= 3.0')
  s.add_development_dependency('guard')
  s.add_development_dependency('guard-rspec')
  s.add_development_dependency('ruby_gntp')
  s.add_development_dependency('rb-fsevent')
  s.add_development_dependency('pry')
  s.add_development_dependency('pimpmychangelog')
  s.add_development_dependency('rubocop')

  s.add_dependency('grit')
  s.add_dependency('logging')
  s.add_dependency('thor')
end
