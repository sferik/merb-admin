class League
  include DataMapper::Resource

  property(:id, Serial)
  property(:created_at, DateTime)
  property(:updated_at, DateTime)
  property(:name, String, :required => true, :index => true)

  has(n, :divisions)
  has(n, :teams)
end
