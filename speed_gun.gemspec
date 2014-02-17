# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'speed_gun/version'

Gem::Specification.new do |spec|
  spec.name          = 'speed_gun'
  spec.version       = SpeedGun::VERSION
  spec.authors       = ['Sho Kusano']
  spec.email         = ['rosylilly@aduca.org']
  spec.summary       = %q{Better web app profiler for Rails apps}
  spec.description   = %q{Better web app profiler for Rails apps}
  spec.homepage      = 'https://github.com/rosylilly/speed_gun'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.14.1'
  spec.add_development_dependency 'simplecov', '~> 0.8.2'
  spec.add_development_dependency 'simplecov-console'
  spec.add_development_dependency 'rack-test'

  spec.add_dependency 'hashie'
end
