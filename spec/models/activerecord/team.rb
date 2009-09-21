class Team < ActiveRecord::Base
  validates_presence_of :league_id
  validates_numericality_of :league_id
  validates_presence_of :division_id
  validates_numericality_of :division_id
  validates_presence_of :name

  belongs_to :league
  belongs_to :division
  has_many :players
end
