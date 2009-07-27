require "rubygems"
require "rake/gempackagetask"

require "merb-core"
require "merb-core/tasks/merb"

GEM_NAME = "merb-admin"
AUTHOR = "Erik Michaels-Ober"
EMAIL = "sferik@gmail.com"
HOMEPAGE = "http://twitter.com/sferik"
SUMMARY = "MerbAdmin is a Merb slice that uses your DataMapper models to provide an easy-to-use, Django-style interface for content managers."
GEM_VERSION = Merb::VERSION

spec = Gem::Specification.new do |s|
  s.rubyforge_project = "merb"
  s.name = GEM_NAME
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.markdown", "LICENSE"]
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.add_dependency("merb-slices", Merb::VERSION)
  s.require_path = "lib"
  s.files = %w(LICENSE README.markdown Rakefile) + Dir.glob("{lib,spec,app,public,stubs}/**/*")
  s.post_install_message = <<-POST_INSTALL_MESSAGE
#{"*" * 80}

  WARNING: MerbAdmin does not currently implement any authentication!
  Do not deploy to production without writing an authentication strategy.

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
