# MerbAdmin
MerbAdmin is a Merb plugin that provides an easy-to-use interface for managing your data.

[It offers an array of features.](http://sferik.tadalist.com/lists/1352791/public)

[Take it for a test drive with sample data.](http://merb-admin.heroku.com/)

## Screenshots
![List view](https://github.com/sferik/merb-admin/raw/master/screenshots/list.png "List view")
![Edit view](https://github.com/sferik/merb-admin/raw/master/screenshots/edit.png "Edit view")

## Installation
In your app, add the following dependency to <tt>Gemfile</tt>:

    gem "merb-admin", "~> 0.8.8"
Bundle it:

    bundle install
Add the following route to <tt>config/router.rb</tt>:

    add_slice(:merb_admin, :path_prefix => "admin")
Then, run the following rake task:

    rake slices:merb-admin:install

## Configuration (optional)
If you're feeling crafty, you can set a couple configuration options in <tt>config/init.rb</tt>:

    Merb::BootLoader.before_app_loads do
      Merb::Slices::config[:merb_admin][:app_name] = "My App"
      Merb::Slices::config[:merb_admin][:per_page] = 100
      Merb::Slices::config[:merb_admin][:excluded_models] = ["Top", "Secret"]
    end

## Usage
Start the server:

    merb
You should now be able to administer your site at
[http://localhost:4000/admin](http://localhost:4000/admin).

## WARNING
MerbAdmin does not implement any authorization scheme. Make sure to apply
authorization logic before deploying to production!

## Contributing
In the spirit of [free software][free-sw], **everyone** is encouraged to help
improve this project.

[free-sw]: http://www.fsf.org/licensing/essays/free-sw.html

Here are some ways *you* can contribute:

* by using alpha, beta, and prerelease versions
* by reporting bugs
* by suggesting new features
* by writing or editing documentation
* by writing specifications
* by writing code (**no patch is too small**: fix typos, add comments, clean up
  inconsistent whitespace)
* by refactoring code
* by fixing [issues][]
* by reviewing patches

[issues]: https://github.com/sferik/merb-admin/issues

## Acknowledgments
Many thanks to:

* [Wilson Miner](http://www.wilsonminer.com/) for contributing the stylesheets and javascripts from [Django](http://www.djangoproject.com/)
* [Aaron Wheeler](http://fightinjoe.com/) for contributing libraries from [Merb AutoScaffold](https://github.com/fightinjoe/merb-autoscaffold)
* [Lori Holden](http://loriholden.com/) for contributing the [merb-pagination](https://github.com/lholden/merb-pagination) helper
* [Jacques Crocker](http://merbjedi.com/) for adding support for [namespaced models](https://github.com/merbjedi/merb-admin/commit/8139e2241038baf9b72452056fcdc7c340d79275)
* [Jeremy Evans](http://code.jeremyevans.net/) and [Pavel Kunc](http://www.merboutpost.com) for reviewing the [patch](https://github.com/sferik/merb-admin/commit/061fa28f652fc9214e9cf480d66870140181edef) to add [Sequel](http://sequel.rubyforge.org/) support
* [Jonah Honeyman](https://github.com/jonuts) for fixing a [bug](https://github.com/sferik/merb-admin/commit/9064d10382eadd1ed7a882ef40e2c6a65edfef2c) and adding the [:excluded_models option](https://github.com/sferik/merb-admin/commit/f6157d1c471dd85162481d6926578164be1b9673)
