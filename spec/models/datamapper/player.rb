class Player
  include DataMapper::Resource

  property(:id, Serial)
  property(:created_at, DateTime)
  property(:updated_at, DateTime)
  property(:deleted_at, ParanoidDateTime)
  property(:team_id, Integer, :index => true)
  property(:name, String, :length => 100, :required => true, :index => true)
  property(:position, String, :index => true)
  property(:number, Integer, :required => true)
  property(:retired, Boolean, :default => false)
  property(:injured, Boolean, :default => false)
  property(:born_on, Date)
  property(:notes, Text)

  validates_is_unique(:number, :scope => :team_id, :message => "There is already a player with that number on this team")

  belongs_to(:team)
  has(1, :draft)
end
