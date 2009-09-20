Draft.fixture {{
  :player_id => /\d{1,5}/.gen,
  :team_id => /\d{1,5}/.gen,
  :date => Date.today,
  :round => /\d/.gen,
  :pick => /\d{1,2}/.gen,
  :overall => /\d{1,3}/.gen,
  :college => "#{/\w{5,10}/.gen.capitalize} University",
  :notes => /[:sentence:]/.gen,
}}
