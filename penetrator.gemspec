# -*- encoding: utf-8 -*-
require File.expand_path('../lib/penetrator/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Yury Batenko"]
  gem.email         = ["jurbat@gmail.com"]
  gem.description   = %q{Implement traits behavior to get rid of code repetition}
  gem.summary       = %q{Implement traits behavior to get rid of code repetition}
  gem.homepage      = "https://github.com/svenyurgensson/penetrator"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "penetrator"
  gem.require_paths = ["lib"]
  gem.version       = Penetrator::VERSION
  if RUBY_VERSION < '1.9.0'
    gem.add_development_dependency "minitest"
  end
  gem.add_development_dependency "mocha"
end
