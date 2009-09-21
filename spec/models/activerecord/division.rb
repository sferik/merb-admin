class Division < ActiveRecord::Base
  validates_presence_of :league_id
  validates_numericality_of :league_id
  validates_presence_of :name

  belongs_to :league
  has_many :teams
end
