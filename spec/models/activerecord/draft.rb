class Draft < ActiveRecord::Base
  validates_presence_of :player_id
  validates_numericality_of :player_id
  validates_presence_of :team_id
  validates_numericality_of :team_id
  validates_presence_of :date
  validates_presence_of :round
  validates_numericality_of :round
  validates_presence_of :pick
  validates_numericality_of :pick
  validates_presence_of :overall
  validates_numericality_of :overall

  belongs_to :team
  belongs_to :player
end
