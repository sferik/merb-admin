class CreatePlayers < Sequel::Migration
  def up
    create_table(:players) do
      primary_key(:id)
      DateTime(:created_at)
      DateTime(:updated_at)
      DateTime(:deleted_at)
      foreign_key(:team_id, :table => :teams)
      String(:name, :limit => 100, :null => false)
      String(:position, :limit => 50)
      Integer(:number, :null => false)
      TrueClass(:retired, :default => false)
      TrueClass(:injured, :default => false)
      Date(:born_on)
      String(:notes, :text=>true)
    end
  end

  def down
    drop_table(:players)
  end
end
