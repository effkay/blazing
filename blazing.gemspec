# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "blazing/version"

Gem::Specification.new do |s|
  s.name        = "blazing"
  s.version     = Blazing::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Felipe Kaufmann"]
  s.email       = ["felipekaufmann@gmail.com"]
  s.homepage    = "https://github.com/effkay/blazing"
  s.summary     = %q{blazing fast deployment}
  s.description = %q{git push deployent utility, ready to be extended by your own recipes}
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # TODO: better to use ~ ?
  s.add_dependency "thor", ">= 0.14.6"

  # TODO: Get rid of those, just used for guessing recipe names etc in lib/recipes.rb
  s.add_dependency "activesupport", ">= 3.0.5"
  s.add_dependency "i18n"
  s.add_dependency "grit"
end
