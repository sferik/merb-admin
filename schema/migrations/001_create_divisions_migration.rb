class CreateDivisionsMigration < ActiveRecord::Migration
  def self.up
    create_table :divisions do |t|
      t.timestamps
      t.integer :league_id
      t.string :name, :limit => 50, :null => false
    end
    add_index :divisions, :league_id
    add_index :divisions, :name
  end

  def self.down
    drop_table :divisions
  end
end
