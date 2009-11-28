require 'abstract_model'

namespace :slices do
  namespace :"merb-admin" do

    # # Uncomment the following lines and edit the pre defined tasks
    #
    # # implement this to test for structural/code dependencies
    # # like certain directories or availability of other files
    # desc "Test for any dependencies"
    # task :preflight do
    # end
    #
    # # implement this to perform any database related setup steps
    # desc "Migrate the database"
    # task :migrate do
    # end

    desc "Copies sample models, copies and runs sample migrations, and loads sample data into your app"
    task :activerecord => ["activerecord:copy_sample_models", "activerecord:copy_sample_migrations", "activerecord:migrate", "load_sample_data"]
    namespace :activerecord do
      desc "Copies sample models into your app"
      task :copy_sample_models do
        copy_models(:activerecord)
      end

      desc "Copies sample migrations into your app"
      task :copy_sample_migrations do
        copy_migrations(:activerecord)
      end

      desc "Migrate the database to the latest version"
      task :migrate do
        Rake::Task["db:migrate"].reenable
        Rake::Task["db:migrate"].invoke
      end
    end

    desc "Copies sample models, runs sample migrations, and loads sample data into your app"
    task :datamapper => ["datamapper:copy_sample_models", "datamapper:migrate", "load_sample_data"]
    namespace :datamapper do
      desc "Copies sample models into your app"
      task :copy_sample_models do
        copy_models(:datamapper)
      end

      desc "Perform non destructive automigration"
      task :migrate do
        Rake::Task["db:automigrate"].reenable
        Rake::Task["db:automigrate"].invoke
      end
    end

    desc "Copies sample models, copies and runs sample migrations, and loads sample data"
    task :sequel => ["sequel:copy_sample_models", "sequel:copy_sample_migrations", "sequel:migrate", "load_sample_data"]
    namespace :sequel do
      desc "Copies sample models into your app"
      task :copy_sample_models do
        copy_models(:sequel)
      end

      desc "Copies sample migrations into your app"
      task :copy_sample_migrations do
        copy_migrations(:sequel)
      end

      desc "Perform migration using migrations in schema/migrations"
      task :migrate do
        require 'sequel/extensions/migration'
        Rake::Task["sequel:db:migrate"].reenable
        Rake::Task["sequel:db:migrate"].invoke
      end
    end

    desc "Loads sample data into your app"
    task :load_sample_data do
      load_data
    end

  end
end

private

def load_data
  begin
    require "mlb"
  rescue LoadError => e
    puts "LoadError: #{e}"
    puts "gem install mlb -s http://gemcutter.org"
    return
  end

  require_models

  puts "Loading current MLB leagues, divisions, teams, and players"
  MLB::Team.all.each do |mlb_team|
    unless league = MerbAdmin::AbstractModel.new("League").first(:conditions => ["name = ?", mlb_team.league])
      league = MerbAdmin::AbstractModel.new("League").create(:name => mlb_team.league)
    end
    unless division = MerbAdmin::AbstractModel.new("Division").first(:conditions => ["name = ?", mlb_team.division])
      division = MerbAdmin::AbstractModel.new("Division").create(:name => mlb_team.division, :league => league)
    end
    unless team = MerbAdmin::AbstractModel.new("Team").first(:conditions => ["name = ?", mlb_team.name])
      team = MerbAdmin::AbstractModel.new("Team").create(:name => mlb_team.name, :logo_url => mlb_team.logo_url, :manager => mlb_team.manager, :ballpark => mlb_team.ballpark, :mascot => mlb_team.mascot, :founded => mlb_team.founded, :wins => mlb_team.wins, :losses => mlb_team.losses, :win_percentage => ("%.3f" % (mlb_team.wins.to_f / (mlb_team.wins + mlb_team.losses))).to_f, :division => division, :league => league)
    end
    mlb_team.players.reject{|player| player.number.nil?}.each do |player|
      MerbAdmin::AbstractModel.new("Player").create(:name => player.name, :number => player.number, :position => player.position, :team => team)
    end
  end
end

def copy_models(orm = nil)
  orm ||= set_orm
  puts "Copying sample #{orm} models into host application - resolves any collisions"
  seen, copied, duplicated = [], [], []
  Dir.glob(File.dirname(__FILE__) / ".." / ".." / "spec" / "models" / orm.to_s.downcase / MerbAdmin.glob_for(:model)).each do |source_filename|
    next if seen.include?(source_filename)
    destination_filename = Merb.dir_for(:model) / File.basename(source_filename)
    mirror_file(source_filename, destination_filename, copied, duplicated)
    seen << source_filename
  end
  copied.each { |f| puts "- copied #{f}" }
  duplicated.each { |f| puts "! duplicated override as #{f}" }
end

def copy_migrations(orm = nil)
  orm ||= set_orm
  puts "Copying sample #{orm} migrations into host application - resolves any collisions"
  seen, copied, duplicated = [], [], []
  Dir.glob(File.dirname(__FILE__) / ".." / ".." / "spec" / "migrations" / orm.to_s.downcase / "*.rb").each do |source_filename|
    next if seen.include?(source_filename)
    destination_filename = Merb.root / "schema" / "migrations" / File.basename(source_filename)
    mirror_file(source_filename, destination_filename, copied, duplicated)
    seen << source_filename
  end
  copied.each { |f| puts "- copied #{f}" }
  duplicated.each { |f| puts "! duplicated override as #{f}" }
end

def require_models
  Dir.glob(Merb.dir_for(:model) / Merb.glob_for(:model)).each do |model_filename|
    require model_filename
  end
end

def set_orm(orm = nil)
  orm || ENV['MERB_ORM'] || (Merb.orm != :none ? Merb.orm : nil) || :datamapper
end

def mirror_file(source, dest, copied = [], duplicated = [], postfix = '_override')
  base, rest = split_name(source)
  dst_dir = File.dirname(dest)
  dup_path = dst_dir / "#{base}#{postfix}.#{rest}"
  if File.file?(source)
    FileUtils.mkdir_p(dst_dir) unless File.directory?(dst_dir)
    if File.exists?(dest) && !File.exists?(dup_path) && !FileUtils.identical?(source, dest)
      # copy app-level override to *_override.ext
      FileUtils.copy_entry(dest, dup_path, false, false, true)
      duplicated << dup_path.relative_path_from(Merb.root)
    end
    # copy gem-level original to location
    if !File.exists?(dest) || (File.exists?(dest) && !FileUtils.identical?(source, dest))
      FileUtils.copy_entry(source, dest, false, false, true)
      copied << dest.relative_path_from(Merb.root)
    end
  end
end

def split_name(name)
  file_name = File.basename(name)
  mres = /^([^\/\.]+)\.(.+)$/i.match(file_name)
  mres.nil? ? [file_name, ''] : [mres[1], mres[2]]
end
