class Player
  include DataMapper::Resource

  property :id, Serial
  property :created_at, DateTime
  property :updated_at, DateTime
  property :deleted_at, ParanoidDateTime
  property :team_id, Integer, :nullable => false, :index => true
  property :number, Integer, :nullable => false
  property :name, String, :length => 100, :nullable => false
  property :position, Enum[:pitcher, :catcher, :first, :second, :third, :shortstop, :left, :center, :right]
  property :sex, Enum[:male, :female]
  property :batting_average, Float, :default => 0.0, :precision => 4, :scale => 3
  property :injured, Boolean, :default => false
  property :retired, TrueClass, :default => false
  property :born_on, Date
  property :wake_at, Time
  property :notes, Text

  belongs_to :team
  has 1, :draft
end

Player.fixture {{
  :team_id => /\d{1,5}/.gen,
  :number => /\d{1,2}/.gen,
  :name => "#{/\w{3,10}/.gen.capitalize} #{/\w{5,10}/.gen.capitalize}",
  :position => Player.properties[:position].type.flag_map.values[rand(Player.properties[:position].type.flag_map.length)],
  :sex => Player.properties[:sex].type.flag_map.values[rand(Player.properties[:sex].type.flag_map.length)],
}}
