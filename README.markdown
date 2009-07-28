# MerbAdmin

**MerbAdmin is a Merb slice that uses your DataMapper models to provide an easy-to-use, Django-style interface for content managers.**

It currently implements the features listed [here](http://sferik.tadalist.com/lists/1352791/public).

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

Now you should be able to administer your site at [http://localhost:4000/admin](http://localhost:4000/admin).

Please report any problems you encounter to <sferik@gmail.com>.

## WARNING

MerbAdmin does not currently implement any authentication! Do not deploy to production without writing an authentication strategy.

## Acknowledgements

Many thanks to [Wilson Miner](http://www.wilsonminer.com/) for contributing the stylesheets and javascripts from [Django](http://www.djangoproject.com/).

Also, thanks to [beer](http://www.anchorbrewing.com/).
