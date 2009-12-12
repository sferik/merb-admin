class Division
  include DataMapper::Resource

  property(:id, Serial)
  property(:created_at, DateTime)
  property(:updated_at, DateTime)
  property(:league_id, Integer, :required => true, :index => true)
  property(:name, String, :required => true, :index => true)

  belongs_to(:league)
  has(n, :teams)
end
