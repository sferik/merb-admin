class Draft
  include DataMapper::Resource

  property(:id, Serial)
  property(:created_at, DateTime)
  property(:updated_at, DateTime)
  property(:player_id, Integer, :required => true, :index => true)
  property(:team_id, Integer, :required => true, :index => true)
  property(:date, Date, :required => true)
  property(:round, Integer, :required => true)
  property(:pick, Integer, :required => true)
  property(:overall, Integer, :required => true)
  property(:college, String, :length => 100, :index => true)
  property(:notes, Text)

  belongs_to(:team)
  belongs_to(:player)
end
