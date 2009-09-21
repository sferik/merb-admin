class CreatePlayersMigration < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.timestamps
      t.datetime :deleted_at
      t.integer :team_id
      t.string :name, :limit => 50, :null => false
      t.integer :number
      t.integer :position
      t.integer :sex
      t.float :batting_average, :default => 0.0
      t.boolean :injured, :default => false
      t.date :born_on
      t.timestamp :wake_at
      t.text :notes
    end
    add_index :players, :team_id
  end

  def self.down
    drop_table :players
  end
end
