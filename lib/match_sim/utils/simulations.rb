module MatchSim
    module Utils
        module Simulations
            extend MatchSim

            RANDOM = Random.new

            def sim_match(team1, team2, console=false)
                return Match.new(team1, team2).simulate(console=console)
            end

            def sim_teams(team1, team2, matches_num=100)
                # Simulates a matches betwen teams.
                # Returns a percent of team1 winnings.

                results = 0.0
                for i in 1..matches_num do
                    results += RANDOM.rand > 0.5 ? (Match.new(team1, team2).simulate()[:radiant_win] ? 1 : 0) : (Match.new(team2, team1).simulate()[:radiant_win] ? 0 : 1)
                end

                return results / matches_num
            end
            
            def sim_ligue(teams, matches_num=100)
                # Simulates a random matches betwen teams in ligue.

                for i in 1..matches_num do
                    opponents = teams.sample(2)
                    RANDOM.rand >= 0.5 ? MatchSim::Match.new(opponents[0], opponents[1]).simulate : MatchSim::Match.new(opponents[1], opponents[0]).simulate
                end
            
                avg = [0, 0, 0, 0, 0]
                teams.each do |team|
                    puts team, '---'
                    team.each {|player| puts player}
                    # (1..5).each {|i| puts team.get_player(i)}
                    (1..5).each {|i| avg[i - 1] += team.get_player(i).elo / teams.length}
                    puts("===============")
                end
            
                puts avg
            end
        end
    end
end