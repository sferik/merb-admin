require "rubygems"
require "merb-core"
require "merb-core/tasks/merb"

GEM_NAME = "merb-admin"
AUTHOR = "Erik Michaels-Ober"
EMAIL = "sferik@gmail.com"
HOMEPAGE = "http://github.com/sferik/merb-admin"
SUMMARY = "MerbAdmin is a Merb plugin that provides an easy-to-use interface for managing your data."
MERB_GEM_VERSION = "1.0.15"

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = GEM_NAME
    gemspec.summary = SUMMARY
    gemspec.description = gemspec.summary
    gemspec.author = AUTHOR
    gemspec.email = EMAIL
    gemspec.homepage = HOMEPAGE
    gemspec.files.exclude("config/*", "screenshots/*")
    gemspec.add_dependency("merb-slices", ">= #{MERB_GEM_VERSION}")
    gemspec.add_dependency("merb-assets", ">= #{MERB_GEM_VERSION}")
    gemspec.add_dependency("merb-helpers", ">= #{MERB_GEM_VERSION}")
    gemspec.add_dependency("builder", ">= 2.1.2")
    gemspec.add_development_dependency("rspec", ">= 1.2.9")
    gemspec.post_install_message = <<-POST_INSTALL_MESSAGE
#{"*" * 80}

  WARNING: MerbAdmin does not implement any authorization scheme.
  Make sure to apply authorization logic before deploying to production!

#{"*" * 80}
POST_INSTALL_MESSAGE
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

require "spec/rake/spectask"
require "merb-core/test/tasks/spectasks"
desc "Default: run spec examples"
task :default => "spec"
