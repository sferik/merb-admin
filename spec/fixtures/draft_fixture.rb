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
  property :college, String, :length => 100
  property :notes, Text

  belongs_to :team
  belongs_to :player
end

Draft.fixture {{
  :player_id => /\d{1,5}/.gen,
  :team_id => /\d{1,5}/.gen,
  :date => Date.today,
  :round => /\d/.gen,
  :pick => /\d{1,2}/.gen,
  :overall => /\d{1,3}/.gen,
  :college => "#{/\w{5,10}/.gen.capitalize} University",
  :notes => /[:sentence:]/.gen,
}}
