# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "blazing/version"

Gem::Specification.new do |s|
  s.name        = "blazing"
  s.version     = Blazing::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Felipe Kaufmann"]
  s.email       = ["felipekaufmann@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{blazing fast deployment}
  s.description = %q{git push style deployments for the masses}

  s.rubyforge_project = "blazing"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # TODO: better to use ~ ?
  s.add_dependency "thor", ">= 0.14.6"
end
