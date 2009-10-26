class League < Sequel::Model
  set_primary_key(:id)
  plugin(:timestamps, :update_on_create => true)
  plugin(:validation_helpers)

  one_to_many(:divisions)
  one_to_many(:teams)

  self.raise_on_save_failure = false
  self.raise_on_typecast_failure = false
  def validate
    validates_presence(:name)
  end
end
