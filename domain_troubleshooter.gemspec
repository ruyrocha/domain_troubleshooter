# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'domain_troubleshooter/version'

Gem::Specification.new do |spec|
  spec.name          = "domain_troubleshooter"
  spec.version       = Domain::Troubleshooter::VERSION
  spec.authors       = ["Ruy Rocha"]
  spec.email         = ["admin@ruyrocha.com"]

  spec.summary       = %q{Domain names troubleshooter.}
  spec.homepage      = "http://github.com/ruyrocha/domain_troubleshooter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 11.3"
  spec.add_development_dependency "rspec", "~> 3.5"

  spec.add_runtime_dependency "public_suffix"
  spec.add_runtime_dependency "whois"
  spec.add_runtime_dependency "whois-parser"
end
