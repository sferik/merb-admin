class Team
  include DataMapper::Resource

  property :id, Serial
  property :created_at, DateTime
  property :updated_at, DateTime
  property :league_id, Integer, :nullable => false, :index => true
  property :division_id, Integer, :nullable => false, :index => true
  property :name, String, :nullable => false, :index => true
  property :colors, Flag[:beige, :black, :blue, :bronze, :brown, :cool, :copper, :cream, :gold, :gray, :green, :khaki, :maroon, :midnight, :navy, :orange, :pink, :purple, :red, :silver, :tan, :turquoise, :violet, :white, :yellow]

  belongs_to :league
  belongs_to :division
  has n, :players
end
