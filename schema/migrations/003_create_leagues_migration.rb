class CreateLeaguesMigration < ActiveRecord::Migration
  def self.up
    create_table :leagues do |t|
      t.timestamps
      t.string :name, :limit => 50, :null => false
    end
    add_index :leagues, :name
  end

  def self.down
    drop_table :leagues
  end
end
