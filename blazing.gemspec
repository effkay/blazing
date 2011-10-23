# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "blazing/version"

Gem::Specification.new do |s|
  s.name        = "blazing"
  s.version     = Blazing::VERSION
  s.authors     = ["Felipe Kaufmann"]
  s.email       = ["felipekaufmann@gmail.com"]
  s.homepage    = "https://github.com/effkay/blazing"
  s.summary     = %q{blazing fast deployment}
  s.description = %q{git push deployent utility, ready to be extended by your own recipes}

  s.rubyforge_project = "blazing"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_development_dependency('rdoc')
  s.add_development_dependency('rake','~> 0.9.2')
  s.add_development_dependency('rspec')
  s.add_development_dependency('guard')
  s.add_development_dependency('guard-rspec')
  s.add_development_dependency('growl')
  s.add_development_dependency('rb-fsevent')
  s.add_dependency('grit')

  # TODO: Get rid of those, just used for guessing recipe names etc in lib/recipes.rb
  s.add_dependency "activesupport"
  s.add_dependency "i18n"
end
