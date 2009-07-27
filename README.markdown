# MerbAdmin

MerbAdmin is a Merb slice that uses your DataMapper models to provide an easy-to-use, Django-style interface for content managers.

## Get it

    sudo gem install sferik-merb-admin -s http://gems.github.com

Alternatively, you build the gem yourself:

    git clone git://github.com/sferik/merb-admin.git
    cd merb-admin
    sudo rake install

## Install it

In your app, add the following dependency to `config/dependencies.rb`

    dependency "merb-admin", merb_gems_version

Add the following route to `config/router.rb`

    slice(:merb_admin)

Then run the following rake task:

    rake slices:merb_admin:install

## Run it

Start your server.  If everything worked correctly, it should log the messages:
    ~ Loaded slice 'MerbAdmin' ...
    ~ Activating slice 'MerbAdmin' ...

Now you should be able to administer your site at `http://localhost:4000/admin`

Please report any problems you encounter to <sferik@gmail.com>.

## WARNING

Merb-admit does not currently implement any authentication! Do not deploy to production without writing an authentication strategy.

## Acknowledgements

Many thanks to [Wilson Miner](http://www.wilsonminer.com/) for contributing the JavaScript and CSS from the [Django](http://www.djangoproject.com/) admin site.

Also, thanks to [beer](http://www.anchorbrewing.com/).

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
