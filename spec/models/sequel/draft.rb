class Draft < Sequel::Model
  set_primary_key(:id)
  plugin(:timestamps, :update_on_create => true)
  plugin(:validation_helpers)

  many_to_one(:team)
  many_to_one(:player)

  self.raise_on_save_failure = false
  self.raise_on_typecast_failure = false
  def validate
    validates_numeric(:player_id, :only_integer => true, :allow_blank => true)
    validates_numeric(:team_id, :only_integer => true, :allow_blank => true)
    validates_presence(:date)
    validates_numeric(:round, :only_integer => true)
    validates_numeric(:pick, :only_integer => true)
    validates_numeric(:overall, :only_integer => true)
  end
end
