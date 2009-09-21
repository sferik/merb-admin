class CreateTeamsMigration < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.timestamps
      t.integer :league_id
      t.integer :division_id
      t.string :name, :limit => 50, :null => false
      t.integer :colors
    end
    add_index :teams, :division_id
    add_index :teams, :league_id
    add_index :teams, :name
  end

  def self.down
    drop_table :teams
  end
end
