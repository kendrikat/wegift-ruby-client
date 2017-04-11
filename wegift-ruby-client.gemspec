# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wegift/version'

Gem::Specification.new do |spec|
  spec.name          = 'wegift-ruby-client'
  spec.version       = Wegift::VERSION
  spec.authors       = ['Klaas Endrikat']
  spec.email         = ['klaas.endrikat@googlemail.com']

  spec.summary       = %q{A simple Ruby client for the WEGIFT API}
  spec.homepage      = 'https://github.com/kendrikat/wegift-ruby-client'
  spec.license       = 'MIT'


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.1'

  spec.add_dependency 'faraday', '>= 0.9.2'
  spec.add_dependency 'json'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'dotenv'
end
