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
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-console'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'coveralls'

  spec.add_dependency 'hashie'
  spec.add_dependency 'msgpack'
  spec.add_dependency 'slim'
  spec.add_dependency 'sinatra', '~> 1.4.4'
end
