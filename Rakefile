require "rubygems"
require "rake/gempackagetask"

require "merb-core"
require "merb-core/tasks/merb"

GEM_NAME = "merb-admin"
AUTHOR = "Erik Michaels-Ober"
EMAIL = "sferik@gmail.com"
HOMEPAGE = "http://github.com/sferik/merb-admin"
SUMMARY = "MerbAdmin is a Merb plugin that provides an easy-to-use interface for managing your data."
GEM_VERSION = "0.5.5"

spec = Gem::Specification.new do |s|
  s.rubyforge_project = "merb"
  s.name = GEM_NAME
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = false
  s.extra_rdoc_files = ["README.markdown", "LICENSE"]
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.add_dependency("merb-slices", ">= 1.0.12")
  s.add_dependency("builder", ">= 2.1.2")
  s.require_path = "lib"
  s.files = %w(LICENSE README.markdown Rakefile) + Dir.glob("{app,lib,public,schema,spec,stubs}/**/*")
  s.post_install_message = <<-POST_INSTALL_MESSAGE
#{"*" * 80}

  WARNING: MerbAdmin does not implement any authorization scheme.
  Make sure to apply authorization logic before deploying to production!

#{"*" * 80}
POST_INSTALL_MESSAGE
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Install the gem"
task :install do
  Merb::RakeHelper.install(GEM_NAME, :version => GEM_VERSION)
end

desc "Uninstall the gem"
task :uninstall do
  Merb::RakeHelper.uninstall(GEM_NAME, :version => GEM_VERSION)
end

desc "Create a gemspec file"
task :gemspec do
  File.open("#{GEM_NAME}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

require "spec/rake/spectask"
require "merb-core/test/tasks/spectasks"
desc "Default: run spec examples"
task :default => "spec"
