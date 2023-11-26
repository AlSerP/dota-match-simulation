require_relative 'lib/match_sim'

include MatchSim::Utils::Simulations
# extend MatchSim::Utils::Simulations
# include MatchSim::Utils::Generative::Teams

# teams = get_main_teams()

# puts sim_ligue(teams, 100)
# sim_match(teams[0], teams[1], true)


t1 = MatchSim::Utils::Generative::Team.build('t1')
t2 = MatchSim::Utils::Generative::Team.build('t2')

# puts MatchSim::Utils::Simulations.instance_methods.include? :sim_match
# MatchSim::Utils::Simulations.sim_match(t1, t2, true)
sim_match(t1, t2, true)
