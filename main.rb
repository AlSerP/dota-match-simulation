require_relative 'lib/match_sim'

include MatchSim::Utils::Simulations
# extend MatchSim::Utils::Simulations
# include MatchSim::Utils::Generative::Teams

# teams = get_main_teams()

# puts sim_ligue(teams, 100)
# sim_match(teams[0], teams[1], true)


teams = [
  t1 = MatchSim::Utils::Generative::Team.build('t1'),
  t2 = MatchSim::Utils::Generative::Team.build('t1'),
  t3 = MatchSim::Utils::Generative::Team.build('t1'),
  t4 = MatchSim::Utils::Generative::Team.build('t1'),
  t5 = MatchSim::Utils::Generative::Team.build('t2'),
  t6 = MatchSim::Utils::Generative::Team.build('t2'),
  t7 = MatchSim::Utils::Generative::Team.build('t2'),
  t8 = MatchSim::Utils::Generative::Team.build('t2')
]

puts sim_ligue(teams, 20)

# puts MatchSim::Utils::Simulations.instance_methods.include? :sim_match
# MatchSim::Utils::Simulations.sim_match(t1, t2, true)
# sim_match(t1, t2, true)
