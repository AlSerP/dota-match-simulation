require_relative 'lib/match_sim'

include MatchSim::Utils::Simulations

# ----------- MASSIVE TEST
stat = {}
i = 10

i.times do
  teams = [
    MatchSim::Utils::Generative::Team.build('t4'),
    MatchSim::Utils::Generative::Team.build('t1'),
    MatchSim::Utils::Generative::Team.build('t5'),
    MatchSim::Utils::Generative::Team.build('t2'),
    MatchSim::Utils::Generative::Team.build('t6'),
    MatchSim::Utils::Generative::Team.build('t3'),
  ]

  league = MatchSim::League.new(teams, 10)
  results = league.sim

  results.stats.each do |team_stat|
    stat[team_stat.team.name] = stat.fetch(team_stat.team.name, 0) + team_stat.wins.to_f / team_stat.matches
  end
end

stat.keys.each do |team|
  puts "#{team} - #{stat[team] / i * 100}"
end
puts stat

# ----------- LEAGUE TEST

# teams = [
#   MatchSim::Utils::Generative::Team.build('t4'),
#   MatchSim::Utils::Generative::Team.build('t1'),
#   MatchSim::Utils::Generative::Team.build('t5'),
#   MatchSim::Utils::Generative::Team.build('t2'),
#   MatchSim::Utils::Generative::Team.build('t6'),
#   MatchSim::Utils::Generative::Team.build('t3'),
# ]

# league = MatchSim::League.new(teams, 20)
# results = league.sim

# puts results

# ----------- SINGLE TEST

# t1 = MatchSim::Utils::Generative::Team.build('t1')
# t2 = MatchSim::Utils::Generative::Team.build('t6')

# MatchSim::Utils::Simulations.sim_match(t1, t2, true)
# sim_match(t1, t2, true)
