class Team
  include DataMapper::Resource

  property(:id, Serial)
  property(:created_at, DateTime)
  property(:updated_at, DateTime)
  property(:league_id, Integer, :required => true, :index => true)
  property(:division_id, Integer, :required => true, :index => true)
  property(:name, String, :index => true)
  property(:logo_url, String, :length => 255)
  property(:manager, String, :length => 100, :required => true, :index => true)
  property(:ballpark, String, :length => 100, :index => true)
  property(:mascot, String, :length => 100, :index => true)
  property(:founded, Integer, :required => true)
  property(:wins, Integer, :required => true)
  property(:losses, Integer, :required => true)
  property(:win_percentage, Float, :required => true, :precision => 4, :scale => 3)

  belongs_to(:league)
  belongs_to(:division)
  has(n, :players)
end
