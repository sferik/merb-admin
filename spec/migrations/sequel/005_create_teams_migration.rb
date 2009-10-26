class CreateTeams < Sequel::Migration
  def up
    create_table(:teams) do
      primary_key(:id)
      DateTime(:created_at)
      DateTime(:updated_at)
      foreign_key(:league_id, :table => :leagues)
      foreign_key(:division_id, :table => :divisions)
      String(:name, :limit => 50, :null => false)
      String(:logo_url, :limit => 255)
      String(:manager, :limit => 100, :null => false)
      String(:ballpark, :limit => 100)
      String(:mascot, :limit => 100)
      Integer(:founded)
      Integer(:wins)
      Integer(:losses)
      Float(:win_percentage)
    end
  end

  def down
    drop_table(:teams)
  end
end
