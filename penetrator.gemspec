# -*- encoding: utf-8 -*-
require File.expand_path('../lib/penetrator/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Yury Batenko"]
  gem.email         = ["jurbat@gmail.com"]
  gem.description   = %q{Implement traits for using with ruby classes to get rid of repetition in the code}
  gem.summary       = %q{Implement traits for using with ruby classes to get rid of repetition in the code}
  gem.homepage      = "http://github/svenyurgensson/penetrator"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "penetrator"
  gem.require_paths = ["lib"]
  gem.version       = Penetrator::VERSION
  gem.add_development_dependency "mocha"
end
