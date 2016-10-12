# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pronto/phpmd/version'

Gem::Specification.new do |spec|
  spec.name = 'pronto-phpmd'
  spec.version = Pronto::PhpmdVersion::VERSION
  spec.authors = ['Eligijus Vitkauskas']
  spec.email = ['eligijusvitkauskas@gmail.com']

  spec.summary = 'Pronto runner for PHPMD'
  spec.homepage = 'https://github.com/EllisV/pronto-phpmd'
  spec.license = 'MIT'

  spec.files = Dir.glob('lib/**/*.rb') + ['pronto-phpmd.gemspec', 'LICENSE', 'README.md']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency('pronto', '~> 0.7.0')
  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
