class Draft
  include DataMapper::Resource

  property :id, Serial
  property :created_at, DateTime
  property :updated_at, DateTime
  property :player_id, Integer, :nullable => false, :index => true
  property :team_id, Integer, :nullable => false, :index => true
  property :date, Date, :nullable => false
  property :round, Integer, :nullable => false
  property :pick, Integer, :nullable => false
  property :overall, Integer, :nullable => false
  property :college, String, :length => 100, :index => true
  property :notes, Text

  belongs_to :team
  belongs_to :player
end
