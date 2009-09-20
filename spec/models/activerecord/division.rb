class Division < ActiveRecord::Base
  belongs_to :league
  has_many :teams
end
