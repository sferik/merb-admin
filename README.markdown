# MerbAdmin

**MerbAdmin is a merb slice that provides an easy-to-use interface for managing your data.**

It currently has the features listed [here](http://sferik.tadalist.com/lists/1352791/public).

## Get it

At your command prompt, type:

    git clone git://github.com/sferik/merb-admin.git
    cd merb-admin
    sudo rake install

## Install it

In your app, add the following dependency to `config/dependencies.rb`

    dependency "merb-admin"

...add the following route to `config/router.rb`

    slice(:MerbAdmin, :name_prefix => nil, :path_prefix => "", :default_routes => false)

...and then run the following rake task:

    rake slices:merb-admin:install

## Run it

Start your server:
    merb

If everything worked correctly, it should log the messages:
    ~ Loaded slice 'MerbAdmin' ...
    ~ Activating slice 'MerbAdmin' ...

Now you should be able to administer your site at [http://localhost:4000/admin](http://localhost:4000/admin).

Please report any problems you encounter to <sferik@gmail.com>.

## WARNING

MerbAdmin does not implement any authorization scheme. Make sure to apply authorization logic before deploying to production!

## Acknowledgements

Many thanks to [Wilson Miner](http://www.wilsonminer.com/) for contributing the stylesheets and javascripts from [Django](http://www.djangoproject.com/).

Also, thanks to [beer](http://www.anchorbrewing.com/).
