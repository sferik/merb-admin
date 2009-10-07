class League
  include DataMapper::Resource

  property :id, Serial
  property :created_at, DateTime
  property :updated_at, DateTime
  property :name, String, :nullable => false, :index => true

  has n, :divisions
  has n, :teams
end
