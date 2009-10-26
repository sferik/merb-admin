class CreateDrafts < Sequel::Migration
  def up
    create_table(:drafts) do
      primary_key(:id)
      DateTime(:created_at)
      DateTime(:updated_at)
      foreign_key(:player_id, :table => :players)
      foreign_key(:team_id, :table => :teams)
      Date(:date)
      Integer(:round)
      Integer(:pick)
      Integer(:overall)
      String(:college, :limit => 100)
      String(:notes, :text=>true)
    end
  end

  def down
    drop_table(:drafts)
  end
end
