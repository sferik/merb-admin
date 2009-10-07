class Team
  include DataMapper::Resource

  property :id, Serial
  property :created_at, DateTime
  property :updated_at, DateTime
  property :league_id, Integer, :nullable => false, :index => true
  property :division_id, Integer, :nullable => false, :index => true
  property :name, String, :nullable => false, :index => true
  property :logo_image_url, String, :length => 255
  property :manager, String, :length => 100, :nullable => false, :index => true
  property :ballpark, String, :length => 100
  property :mascot, String, :length => 100
  property :founded, Integer, :nullable => false
  property :wins, Integer, :nullable => false
  property :losses, Integer, :nullable => false
  property :win_percentage, Float, :nullable => false, :precision => 4, :scale => 3

  belongs_to :league
  belongs_to :division
  has n, :players
end
