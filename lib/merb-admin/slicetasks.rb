require 'abstract_model'
require 'mlb'

namespace :slices do
  namespace :"merb-admin" do

    # add your own merb-admin tasks here

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

    namespace :activerecord do

      desc "Loads sample ActiveRecord models and data"
      task :load_sample => ["load_sample:activerecord:models", "load_sample:activerecord:data"]
      namespace :load_sample do
        desc "Loads sample ActiveRecord models"
        task :models do
          copy_models(:activerecord)
          copy_migrations(:activerecord)
        end

        desc "Loads sample ActiveRecord data"
        task :data do
          Rake::Task["db:migrate"].reenable
          Rake::Task["db:migrate"].invoke
          load_data
        end
      end

    end

    namespace :datamapper do

      desc "Loads sample DataMapper models and data"
      task :load_sample => ["load_sample:datamapper:models", "load_sample:datamapper:data"]
      namespace :load_sample do
        desc "Loads sample DataMapper models"
        task :models do
          copy_models(:datamapper)
        end

        desc "Loads sample DataMapper data"
        task :data do
          Rake::Task["db:automigrate"].reenable
          Rake::Task["db:automigrate"].invoke
          load_data
        end
      end

    end

  end
end

private

def load_data
  puts "Loading current MLB leagues, divisions, teams, and players"
  MLB.teams.each do |mlb_team|
    unless league = MerbAdmin::AbstractModel.new("League").first(:conditions => ["name = ?", mlb_team.league])
      league = MerbAdmin::AbstractModel.new("League").create(:name => mlb_team.league)
    end
    unless division = MerbAdmin::AbstractModel.new("Division").first(:conditions => ["name = ?", mlb_team.division])
      division = MerbAdmin::AbstractModel.new("Division").create(:name => mlb_team.division, :league => league)
    end
    unless team = MerbAdmin::AbstractModel.new("Team").first(:conditions => ["name = ?", mlb_team.name])
      team = MerbAdmin::AbstractModel.new("Team").create(:name => mlb_team.name, :logo_url => mlb_team.logo_url, :manager => mlb_team.manager, :ballpark => mlb_team.ballpark, :mascot => mlb_team.mascot, :founded => mlb_team.founded, :wins => mlb_team.wins, :losses => mlb_team.losses, :win_percentage => ("%.3f" % (mlb_team.wins.to_f / (mlb_team.wins + mlb_team.losses))).to_f, :division => division, :league => league)
    end
    mlb_team.players.each do |player|
      MerbAdmin::AbstractModel.new("Player").create(:name => player.name, :number => player.number, :position => player.position, :team => team)
    end
  end
end

def copy_models(orm = nil)
  orm ||= set_orm
  puts "Copying sample #{orm} models into host application - resolves any collisions"
  seen, copied, duplicated = [], [], []
  Dir.glob(File.dirname(__FILE__) / ".." / ".." / "spec" / "models" / orm.to_s.downcase / MerbAdmin.glob_for(:model)).each do |source_filename|
    destination_filename = Merb.dir_for(:model) / File.basename(source_filename)
    next if seen.include?(source_filename)
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
  Dir.glob(File.dirname(__FILE__) / ".." / ".." / "schema" / "migrations" / "*.rb").each do |source_filename|
    destination_filename = Merb.root / "schema" / "migrations" / File.basename(source_filename)
    next if seen.include?(source_filename)
    mirror_file(source_filename, destination_filename, copied, duplicated)
    seen << source_filename
  end
  copied.each { |f| puts "- copied #{f}" }
  duplicated.each { |f| puts "! duplicated override as #{f}" }
end

def require_models(orm = nil)
  orm ||= set_orm
  Dir.glob(File.dirname(__FILE__) / "models" / orm.to_s.downcase / Merb.glob_for(:model)).each do |model_filename|
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
