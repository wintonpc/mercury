# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mercury/version'

Gem::Specification.new do |spec|
  spec.name          = 'mercury'
  spec.version       = Mercury::VERSION
  spec.authors       = ['Peter Winton']
  spec.email         = ['wintonpc@gmail.com']
  spec.summary       = 'AMQP-backed messaging layer'
  spec.description   = 'Abstracts common patterns used with AMQP'
  spec.homepage      = 'https://github.com/wintonpc/mercury'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'json_spec'
  spec.add_development_dependency 'evented-spec'
  spec.add_development_dependency 'rspec_junit_formatter'

  spec.add_runtime_dependency 'oj', '~> 2.12'
  spec.add_runtime_dependency 'amqp', '~> 1.5'
  spec.add_runtime_dependency 'binding_of_caller', '~> 0.7'
end
