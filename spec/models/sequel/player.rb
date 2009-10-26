class Player < Sequel::Model
  set_primary_key(:id)
  plugin(:timestamps, :update_on_create => true)
  plugin(:validation_helpers)

  many_to_one(:team)
  one_to_many(:drafts, :one_to_one => true)

  self.raise_on_save_failure = false
  self.raise_on_typecast_failure = false
  def validate
    validates_numeric(:number, :only_integer => true)
    validates_unique(:number, :message => "There is already a player with that number on this team") do |dataset|
      dataset.where("team_id = ?", team_id)
    end
  end
end

