# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{merb-admin}
  s.version = "0.1.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Erik Michaels-Ober"]
  s.date = %q{2009-08-06}
  s.description = %q{MerbAdmin is a merb slice that provides an easy-to-use interface for managing your data.}
  s.email = %q{sferik@gmail.com}
  s.extra_rdoc_files = ["README.markdown", "LICENSE"]
  s.files = ["LICENSE", "README.markdown", "Rakefile", "lib/merb-admin", "lib/merb-admin/merbtasks.rb", "lib/merb-admin/slicetasks.rb", "lib/merb-admin/spectasks.rb", "lib/merb-admin.rb", "spec/controller", "spec/controller/forms_spec.rb", "spec/merb-admin_spec.rb", "spec/spec_helper.rb", "app/controllers", "app/controllers/application.rb", "app/controllers/forms.rb", "app/helpers", "app/helpers/application_helper.rb", "app/helpers/forms_helper.rb", "app/views", "app/views/forms", "app/views/forms/_big_decimal.html.erb", "app/views/forms/_date.html.erb", "app/views/forms/_date_time.html.erb", "app/views/forms/_float.html.erb", "app/views/forms/_integer.html.erb", "app/views/forms/_string.html.erb", "app/views/forms/_time.html.erb", "app/views/forms/_true_class.html.erb", "app/views/forms/delete.html.erb", "app/views/forms/edit.html.erb", "app/views/forms/index.html.erb", "app/views/forms/list.html.erb", "app/views/forms/new.html.erb", "app/views/layout", "app/views/layout/_message.html.erb", "app/views/layout/dashboard.html.erb", "app/views/layout/form.html.erb", "app/views/layout/list.html.erb", "public/images", "public/images/arrow-down.gif", "public/images/arrow-up.gif", "public/images/changelist-bg.gif", "public/images/changelist-bg_rtl.gif", "public/images/chooser-bg.gif", "public/images/chooser_stacked-bg.gif", "public/images/default-bg-reverse.gif", "public/images/default-bg.gif", "public/images/deleted-overlay.gif", "public/images/icon-no.gif", "public/images/icon-unknown.gif", "public/images/icon-yes.gif", "public/images/icon_addlink.gif", "public/images/icon_alert.gif", "public/images/icon_calendar.gif", "public/images/icon_changelink.gif", "public/images/icon_clock.gif", "public/images/icon_deletelink.gif", "public/images/icon_error.gif", "public/images/icon_searchbox.png", "public/images/icon_success.gif", "public/images/inline-delete-8bit.png", "public/images/inline-delete.png", "public/images/inline-restore-8bit.png", "public/images/inline-restore.png", "public/images/inline-splitter-bg.gif", "public/images/nav-bg-grabber.gif", "public/images/nav-bg-reverse.gif", "public/images/nav-bg.gif", "public/images/selector-add.gif", "public/images/selector-addall.gif", "public/images/selector-remove.gif", "public/images/selector-removeall.gif", "public/images/selector-search.gif", "public/images/selector_stacked-add.gif", "public/images/selector_stacked-remove.gif", "public/images/tool-left.gif", "public/images/tool-left_over.gif", "public/images/tool-right.gif", "public/images/tool-right_over.gif", "public/images/tooltag-add.gif", "public/images/tooltag-add_over.gif", "public/images/tooltag-arrowright.gif", "public/images/tooltag-arrowright_over.gif", "public/javascripts", "public/javascripts/actions.js", "public/javascripts/calendar.js", "public/javascripts/CollapsedFieldsets.js", "public/javascripts/core.js", "public/javascripts/dateparse.js", "public/javascripts/DateTimeShortcuts.js", "public/javascripts/getElementsBySelector.js", "public/javascripts/i18n.js", "public/javascripts/master.js", "public/javascripts/ordering.js", "public/javascripts/RelatedObjectLookups.js", "public/javascripts/SelectBox.js", "public/javascripts/SelectFilter2.js", "public/javascripts/timeparse.js", "public/javascripts/urlify.js", "public/stylesheets", "public/stylesheets/base.css", "public/stylesheets/changelists.css", "public/stylesheets/dashboard.css", "public/stylesheets/forms.css", "public/stylesheets/global.css", "public/stylesheets/ie.css", "public/stylesheets/layout.css", "public/stylesheets/login.css", "public/stylesheets/master.css", "public/stylesheets/null.css", "public/stylesheets/patch-iewin.css", "public/stylesheets/rtl.css", "public/stylesheets/widgets.css"]
  s.homepage = %q{http://twitter.com/sferik}
  s.post_install_message = %q{********************************************************************************

  WARNING: MerbAdmin does not implement any authorization scheme.
  Make sure to apply authorization logic before deploying to production!

********************************************************************************
}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{merb}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{MerbAdmin is a merb slice that provides an easy-to-use interface for managing your data.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<merb-slices>, ["= 1.0.12"])
      s.add_runtime_dependency(%q<merb_datamapper>, ["= 1.0.12"])
      s.add_runtime_dependency(%q<dm-core>, [">= 0.9.11"])
      s.add_runtime_dependency(%q<dm-is-paginated>, [">= 0.0.1"])
    else
      s.add_dependency(%q<merb-slices>, ["= 1.0.12"])
      s.add_dependency(%q<merb_datamapper>, ["= 1.0.12"])
      s.add_dependency(%q<dm-core>, [">= 0.9.11"])
      s.add_dependency(%q<dm-is-paginated>, [">= 0.0.1"])
    end
  else
    s.add_dependency(%q<merb-slices>, ["= 1.0.12"])
    s.add_dependency(%q<merb_datamapper>, ["= 1.0.12"])
    s.add_dependency(%q<dm-core>, [">= 0.9.11"])
    s.add_dependency(%q<dm-is-paginated>, [">= 0.0.1"])
  end
end
