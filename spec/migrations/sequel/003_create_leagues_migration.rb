class CreateLeagues < Sequel::Migration
  def up
    create_table(:leagues) do
      primary_key(:id)
      DateTime(:created_at)
      DateTime(:updated_at)
      String(:name, :limit => 50, :null => false)
    end
  end

  def down
    drop_table(:leagues)
  end
end
