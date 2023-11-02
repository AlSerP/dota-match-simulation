module MatchSim
    require 'json'

    class Team
        attr_reader :name
    
        def initialize(name, players)
            @name = name
            @players = players
        end

        def get_player(pos)
            return @players[pos - 1]
        end

        def get_mean_elo
            mean_elo = 0.0
            @players.each {|player| mean_elo += player.elo}
            mean_elo /= 5
            return mean_elo 
        end

        def create_match_stat(opponent_team)
            team_stats = []
            for i in 0..4 do
                team_stats.append(PlayerStat.new(@players[i], opponent_team))
            end
            return team_stats
        end
        
        def each(&block)
            @players.each(&block)
        end
    
        def to_s
            return "#{@name}(#{get_mean_elo})"
        end
        
        def to_h(options={})
            {
                name: @name,
            }
        end

        def to_json(*options)
            to_h(*options).to_json(*options)
        end
    end
end
