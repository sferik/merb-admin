Player.fixture {{
  :team_id => /\d{1,5}/.gen,
  :number => /\d{1,2}/.gen,
  :name => "#{/\w{3,10}/.gen.capitalize} #{/\w{5,10}/.gen.capitalize}",
  :position => Player.properties[:position].type.flag_map.values[rand(Player.properties[:position].type.flag_map.length)],
  :sex => Player.properties[:sex].type.flag_map.values[rand(Player.properties[:sex].type.flag_map.length)],
}}
