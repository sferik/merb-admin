require 'rubygems'
require 'merb-core'
require 'merb-slices'
require 'merb-helpers'
require 'merb-assets'
require 'spec'

# Add merb-admin.rb to the search path
Merb::Plugins.config[:merb_slices][:auto_register] = true
Merb::Plugins.config[:merb_slices][:search_path]   = File.join(File.dirname(__FILE__), '..', 'lib', 'merb-admin.rb')

# Require merb-admin.rb explicitly so any dependencies are loaded
require Merb::Plugins.config[:merb_slices][:search_path]

# Using Merb.root below makes sure that the correct root is set for
# - testing standalone, without being installed as a gem and no host application
# - testing from within the host application; its root will be used
Merb.start_environment(
  :testing => true,
  :adapter => 'runner',
  :environment => ENV['MERB_ENV'] || 'test',
  :merb_root => Merb.root,
  :session_store => 'memory'
)

module Merb
  module Test
    module SliceHelper

      # The absolute path to the current slice
      def current_slice_root
        @current_slice_root ||= File.expand_path(File.join(File.dirname(__FILE__), '..'))
      end

      # Whether the specs are being run from a host application or standalone
      def standalone?
        Merb.root == ::MerbAdmin.root
      end

      def setup_orm(orm = nil)
        orm = set_orm(orm)
        orm = orm.to_s.downcase.to_sym
        case orm
        when :activerecord
          require 'active_record'
          require_models(orm)
          unless ActiveRecord::Base.connected?
            ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
            ActiveRecord::Migration.verbose = false
            ActiveRecord::Migrator.run(:up, File.join(File.dirname(__FILE__), "migrations", "activerecord"), 1)
            ActiveRecord::Migrator.run(:up, File.join(File.dirname(__FILE__), "migrations", "activerecord"), 2)
            ActiveRecord::Migrator.run(:up, File.join(File.dirname(__FILE__), "migrations", "activerecord"), 3)
            ActiveRecord::Migrator.run(:up, File.join(File.dirname(__FILE__), "migrations", "activerecord"), 4)
            ActiveRecord::Migrator.run(:up, File.join(File.dirname(__FILE__), "migrations", "activerecord"), 5)
          end
        when :datamapper
          require 'dm-core'
          require 'dm-aggregates'
          require 'dm-validations'
          require_models(orm)
          unless DataMapper::Repository.adapters.key?(:default)
            DataMapper.setup(:default, 'sqlite3::memory:')
            DataMapper.auto_migrate!
          end
        when :sequel
          require 'sequel'
          require 'sequel/extensions/migration'
          Sequel::Migrator.apply(Sequel.sqlite, File.join(File.dirname(__FILE__), "migrations", "sequel"))
          require_models(orm)
        else
          raise "MerbAdmin does not support the #{orm} ORM"
        end
        Merb.orm = orm
      end

      private

      def require_models(orm = nil)
        orm ||= set_orm
        Dir.glob(File.dirname(__FILE__) / "models" / orm.to_s.downcase / Merb.glob_for(:model)).each do |model_filename|
          require model_filename
        end
      end

      def set_orm(orm = nil)
        orm || ENV['MERB_ORM'] || (Merb.orm != :none ? Merb.orm : nil) || :activerecord
      end

    end
  end
end

Spec::Runner.configure do |config|
  config.include(Merb::Test::ViewHelper)
  config.include(Merb::Test::RouteHelper)
  config.include(Merb::Test::ControllerHelper)
  config.include(Merb::Test::SliceHelper)
  config.before(:each) do
    setup_orm
  end
end

# You can add your own helpers here
#
Merb::Test.add_helpers do
  def mount_slice
    if standalone?
      Merb::Router.reset!
      Merb::Router.prepare{add_slice(:merb_admin, :path_prefix => "admin")}
    end
  end
end
