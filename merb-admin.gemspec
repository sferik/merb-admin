# encoding: utf-8
require File.expand_path('../lib/merb-admin/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_dependency 'builder', '~> 2.1'
  gem.add_dependency 'merb-assets', '~> 1.1'
  gem.add_dependency 'merb-helpers', '~> 1.1'
  gem.add_dependency 'merb-slices', '~> 1.1'
  gem.add_development_dependency 'activerecord', '~> 2.3'
  gem.add_development_dependency 'dm-core', '~> 1.0'
  gem.add_development_dependency 'dm-aggregates', '~> 1.0'
  gem.add_development_dependency 'dm-types', '~> 1.0'
  gem.add_development_dependency 'dm-migrations', '~> 1.0'
  gem.add_development_dependency 'dm-sqlite-adapter', '~> 1.0'
  gem.add_development_dependency 'dm-validations', '~> 1.0'
  gem.add_development_dependency 'rspec', '~> 1.3'
  gem.add_development_dependency 'sequel', '~> 3.18'
  gem.add_development_dependency 'webrat', '~> 0.7'
  gem.author = "Erik Michaels-Ober"
  gem.description = %q{MerbAdmin is a Merb plugin that provides an easy-to-use interface for managing your data}
  gem.email = 'sferik@gmail.com'
  gem.files = `git ls-files`.split("\n")
  gem.homepage = 'https://github.com/sferik/merb-admin'
  gem.name = 'merb-admin'
  gem.post_install_message =<<eos
********************************************************************************
  Make sure to add authorization logic before deploying to production!
  WARNING: MerbAdmin does not implement any authorization scheme.
********************************************************************************
eos
  gem.require_paths = ['lib']
  gem.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
  gem.summary = %q{MerbAdmin is a Merb plugin that provides an easy-to-use interface for managing your data}
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.version = MerbAdmin::VERSION
end
