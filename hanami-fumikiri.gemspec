# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hanami/fumikiri/version'

Gem::Specification.new do |spec|
  spec.name          = 'hanami-fumikiri'
  spec.version       = Hanami::Fumikiri::VERSION
  spec.authors       = ['The Hanami Community']
  spec.email         = ['community@hanamirb.com']
  spec.description   = %q{Hanami user authentication. Sometimes its best to do something for someone than for everyone.}
  spec.summary       = %q{Hanami Ruby user authentication based on the community needs. Supports API, CLI and Web interfaces}
  spec.homepage      = 'https://github.com/theCrab/hanami-fumikiri'
  spec.license       = 'MIT'
  spec.platform      = Gem::Platform::RUBY
  spec.files         = `git ls-files -- lib/* CHANGELOG.md LICENSE.md README.md hanami-router.gemspec`.split($/)
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^(test)/})
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.0.0'

  # spec.add_dependency 'http_router',  '~> 0.11'
  spec.add_dependency 'hanami-utils'
  spec.add_dependency 'rack'
  spec.add_dependency 'jwt'
  #
  spec.add_development_dependency 'bundler',          '~> 1.5'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'hanami-controller'
  spec.add_development_dependency 'hanami-model',     '~> 0.6.2'
  spec.add_development_dependency 'rake',             '~> 10'
  # spec.add_development_dependency 'rack-test',      '~> 0.6'
end
