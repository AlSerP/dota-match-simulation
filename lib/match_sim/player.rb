
module MatchSim
    class Player
        attr_reader :elo, :pos, :name
        
        def initialize(name, pos, elo=1000, heroes=[])
            @name = name
            @elo = elo
            @pos = pos
            @heroes = heroes
        end

        def update_elo(elo_diff)
            # @elo += elo_diff
            @elo
        end

        def get_main_heroes
            return @heroes
        end

        def to_s
            return "#{@name} (#{elo})"
        end

        def as_json(options={})
            {
                name: @name,
                elo: @elo,
                pos: @pos,
                heroes: @heroes
            }
        end

        def to_json(*options)
            as_json(*options).to_json(*options)
        end
    end
end
