# -*- encoding: utf-8 -*-
require File.expand_path("../lib/merb-admin/version", __FILE__)

Gem::Specification.new do |s|
  s.add_development_dependency("activerecord", ["~> 2.3"])
  s.add_development_dependency("dm-core", ["~> 1.0"])
  s.add_development_dependency("dm-aggregates", ["~> 1.0"])
  s.add_development_dependency("dm-types", ["~> 1.0"])
  s.add_development_dependency("dm-migrations", ["~> 1.0"])
  s.add_development_dependency("dm-sqlite-adapter", ["~> 1.0"])
  s.add_development_dependency("dm-validations", ["~> 1.0"])
  s.add_development_dependency("thin", ["~> 1.2"])
  s.add_development_dependency("rspec", ["~> 1.3"])
  s.add_development_dependency("sequel", ["~> 3.16"])
  s.add_development_dependency("sqlite3-ruby", ["~> 1.3"])
  s.add_development_dependency("webrat", ["~> 0.7"])
  s.add_runtime_dependency("builder", ["~> 2.1"])
  s.add_runtime_dependency("merb-assets", ["~> 1.1"])
  s.add_runtime_dependency("merb-helpers", ["~> 1.1"])
  s.add_runtime_dependency("merb-slices", ["~> 1.1"])
  s.authors = ["Erik Michaels-Ober"]
  s.description = %q{MerbAdmin is a Merb plugin that provides an easy-to-use interface for managing your data}
  s.email = "sferik@gmail.com"
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.files = `git ls-files`.split("\n")
  s.homepage = "http://rubygems.org/gems/merb-admin"
  s.name = "merb-admin"
  s.post_install_message =<<eos
********************************************************************************
  Make sure to add authorization logic before deploying to production!
  WARNING: MerbAdmin does not implement any authorization scheme.
********************************************************************************
eos
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.rubyforge_project = "merb-admin"
  s.summary = %q{MerbAdmin is a Merb plugin that provides an easy-to-use interface for managing your data}
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = MerbAdmin::VERSION
end
