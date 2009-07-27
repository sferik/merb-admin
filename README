MerbAdmin
=========

A slice for the Merb framework.

------------------------------------------------------------------------------
   

To see all available tasks for MerbAdmin run:

rake -T slices:merb_admin

------------------------------------------------------------------------------

Instructions for installation:

file: config/init.rb

# add the slice as a regular dependency

dependency 'merb-admin'

# if needed, configure which slices to load and in which order

Merb::Plugins.config[:merb_slices] = { :queue => ["MerbAdmin", ...] }

# optionally configure the plugins in a before_app_loads callback

Merb::BootLoader.before_app_loads do
  
  Merb::Slices::config[:merb_admin][:option] = value
  
end

file: config/router.rb

# example: /merb_admin/:controller/:action/:id

add_slice(:MerbAdmin)

# example: /:lang/:controller/:action/:id

add_slice(:MerbAdmin, :path => ':lang')

# example: /:controller/:action/:id

slice(:MerbAdmin)

Normally you should also run the following rake task:

rake slices:merb_admin:install

------------------------------------------------------------------------------

You can put your application-level overrides in:

host-app/slices/merb-admin/app - controllers, models, views ...

Templates are located in this order:

1. host-app/slices/merb-admin/app/views/*
2. gems/merb-admin/app/views/*
3. host-app/app/views/*

You can use the host application's layout by configuring the
merb-admin slice in a before_app_loads block:

Merb::Slices.config[:merb_admin] = { :layout => :application }

By default :merb_admin is used. If you need to override
stylesheets or javascripts, just specify your own files in your layout
instead/in addition to the ones supplied (if any) in 
host-app/public/slices/merb-admin.

In any case don't edit those files directly as they may be clobbered any time
rake merb_admin:install is run.
