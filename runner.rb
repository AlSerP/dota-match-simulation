require_relative 'lib/match_sim'

t1 = MatchSim::Team.new(
  'Team1',
  [
    MatchSim::Player.new('Carry', 1, 1000),
    MatchSim::Player.new('Midder', 2, 1000),
    MatchSim::Player.new('Harder', 3, 1000),
    MatchSim::Player.new('Suppor', 4, 1000),
    MatchSim::Player.new('Full Suppor', 5, 1000),
  ]
)
t2 = MatchSim::Team.new(
  'Team2',
  [
    MatchSim::Player.new('Carry', 1, 1000),
    MatchSim::Player.new('Midder', 2, 2000),
    MatchSim::Player.new('Harder', 3, 1000),
    MatchSim::Player.new('Suppor', 4, 1000),
    MatchSim::Player.new('Full Suppor', 5, 1000),
  ]
)

teams = MatchSim::Utils::Generative::Teams.get_main_teams

league = MatchSim::League.new(teams, 100)
results = league.sim

puts results

# match = MatchSim::Match.new(t1, t2)
# result = match.simulate true
# puts 'RESULT', result
