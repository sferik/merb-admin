Team.fixture {{
  :league_id => /\d{1,5}/.gen,
  :division_id => /\d{1,5}/.gen,
  :name => "The #{/\w{5,10}/.gen.pluralize.capitalize}",
}}
