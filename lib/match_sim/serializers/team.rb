# Serializing Team object to json
module MatchSim
  def to_json(team)
    {
      name: team.name,
      players: [team.players]
    }.to_json
  end
end
