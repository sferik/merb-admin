class League < ActiveRecord::Base
  has_many :divisions
  has_many :teams
end
