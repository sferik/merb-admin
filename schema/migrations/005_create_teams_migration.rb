class CreateTeamsMigration < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.timestamps
      t.integer :league_id
      t.integer :division_id
      t.string :name, :limit => 50, :null => false
      t.string :logo_url, :limit => 255
      t.string :manager, :limit => 100, :null => false
      t.string :ballpark, :limit => 100
      t.string :mascot, :limit => 100
      t.integer :founded
      t.integer :wins
      t.integer :losses
      t.float :win_percentage
    end
    add_index :teams, :division_id
    add_index :teams, :league_id
    add_index :teams, :name
    add_index :teams, :manager
    add_index :teams, :ballpark
    add_index :teams, :mascot
  end

  def self.down
    drop_table :teams
  end
end
