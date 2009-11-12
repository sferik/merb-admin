class Team < Sequel::Model
  set_primary_key(:id)
  plugin(:timestamps, :update_on_create => true)
  plugin(:validation_helpers)

  many_to_one(:league)
  many_to_one(:division)
  one_to_many(:players)

  self.raise_on_save_failure = false
  self.raise_on_typecast_failure = false
  def validate
    validates_numeric(:league_id, :only_integer => true)
    validates_numeric(:division_id, :only_integer => true)
    validates_presence(:manager)
    validates_numeric(:founded, :only_integer => true)
    validates_numeric(:wins, :only_integer => true)
    validates_numeric(:losses, :only_integer => true)
    validates_numeric(:win_percentage)
  end
end
