class Player < ActiveRecord::Base
  validates_presence_of :team_id
  validates_numericality_of :team_id
  validates_presence_of :name
  validates_presence_of :number
  validates_numericality_of :number

  belongs_to :team
  has_one :draft
end
