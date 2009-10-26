class Division < Sequel::Model
  set_primary_key(:id)
  plugin(:timestamps, :update_on_create => true)
  plugin(:validation_helpers)

  many_to_one(:league)
  one_to_many(:teams)

  self.raise_on_save_failure = false
  self.raise_on_typecast_failure = false
  def validate
    validates_numeric(:league_id, :only_integer => true)
    validates_presence(:name)
  end
end
