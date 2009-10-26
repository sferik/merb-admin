class CreateDivisions < Sequel::Migration
  def up
    create_table(:divisions) do
      primary_key(:id)
      DateTime(:created_at)
      DateTime(:updated_at)
      foreign_key(:league_id, :table => :leagues)
      String(:name, :limit => 50, :null => false)
    end
  end

  def down
    drop_table(:divisions)
  end
end
