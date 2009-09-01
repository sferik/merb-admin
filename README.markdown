# MerbAdmin

**MerbAdmin is a Merb plugin that provides an easy-to-use interface for managing your data.**

It currently offers the features listed [here](http://sferik.tadalist.com/lists/1352791/public).

## Get it

At the command prompt, type:

    sudo gem install sferik-merb-admin -s http://gems.github.com

## Install it

In your app, add the following dependency to `config/dependencies.rb`:

    dependency "sferik-merb-admin", "0.3.3", :require_as => "merb-admin"
    dependency "dm-is-paginated", "0.0.1" # if you want pagination support

Add the following route to `config/router.rb`:

    slice(:MerbAdmin, :name_prefix => nil, :path_prefix => "", :default_routes => false)

Then, run the following rake task:

    rake slices:merb-admin:install

## Configure it (optional)

You can configuring the merb-admin slice in a before_app_loads block:

    Merb::BootLoader.before_app_loads do
      Merb::Slices::config[:merb_admin][:app_name] = "My App"
      Merb::Slices::config[:merb_admin][:paginate] = true
      Merb::Slices::config[:merb_admin][:per_page] = 100
    end

## Run it

Start the server:

    merb

You should now be able to administer your site at [http://localhost:4000/admin](http://localhost:4000/admin).

Please report any problems you encounter to <sferik@gmail.com> or [@sferik](http://twitter.com/home/?status=@sferik%20) on Twitter.

## WARNING

MerbAdmin does not implement any authorization scheme. Make sure to apply authorization logic before deploying to production!

## Acknowledgements

Many thanks to:

* [Wilson Miner](http://www.wilsonminer.com) for contributing the stylesheets and javascripts from [Django](http://www.djangoproject.com)
* [Lori Holden](http://loriholden.com/) for providing pagination via [dm-is-paginated](http://github.com/lholden/dm-is-paginated)
* [Aaron Wheeler](http://fightinjoe.com/) for contributing libraries from [Merb AutoScaffold](http://github.com/fightinjoe/merb-autoscaffold)
* [why the lucky stiff](http://whytheluckystiff.net/) for [metaid](http://whytheluckystiff.net/articles/seeingMetaclassesClearly.html)

Also, thanks to [beer](http://www.anchorbrewing.com).
