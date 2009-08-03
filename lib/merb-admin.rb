if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  dependency 'merb-slices', :immediate => true
  Merb::Plugins.add_rakefiles "merb-admin/merbtasks", "merb-admin/slicetasks", "merb-admin/spectasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout - the layout to use; defaults to :merb-admin
  # :mirror - which path component types to use on copy operations; defaults to all
  Merb::Slices::config[:merb_admin][:layout] ||= :merb_admin
  
  # All Slice code is expected to be namespaced inside a module
  module MerbAdmin
    
    # Slice metadata
    self.description = "MerbAdmin is a merb slice that uses your DataMapper models to provide an easy-to-use, Django-style interface for content managers."
    self.version = "0.1.2"
    self.author = "Erik Michaels-Ober"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(MerbAdmin)
    def self.deactivate
    end
    
    def self.setup_router(scope)

      scope.match("/admin(/index)(.:format)", :method => :get).
        to(:controller => "forms", :action => "index").
        name(:admin_dashboard)

      scope.match("/admin/:model_name(/index)(.:format)", :method => :get).
        to(:controller => "forms", :action => "list").
        name(:admin_list)

      scope.match("/admin/:model_name/new(.:format)", :method => :get).
        to(:controller => "forms", :action => "new").
        name(:admin_new)

      scope.match("/admin/:model_name/:id(.:format)", :method => :get).
        to(:controller => "forms", :action => "edit").
        name(:admin_edit)

      scope.match("/admin/:model_name(.:format)", :method => :post).
        to(:controller => "forms", :action => "create").
        name(:admin_create)

      scope.match("/admin/:model_name/:id(.:format)", :method => :put).
        to(:controller => "forms", :action => "update").
        name(:admin_update)

    end
    
  end
  
  # Setup the slice layout for MerbAdmin
  #
  # Use MerbAdmin.push_path and MerbAdmin.push_app_path
  # to set paths to merb-admin-level and app-level paths. Example:
  #
  # MerbAdmin.push_path(:application, MerbAdmin.root)
  # MerbAdmin.push_app_path(:application, Merb.root / 'slices' / 'merb-admin')
  # ...
  #
  # Any component path that hasn't been set will default to MerbAdmin.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  MerbAdmin.setup_default_structure!
  
  # Add dependencies for other MerbAdmin classes below. Example:
  # dependency "merb-admin/other"
  
end
