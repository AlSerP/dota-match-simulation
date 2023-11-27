
module MatchSim
    class Player
        attr_reader :elo, :pos, :name, :condition, :early_game, :late_game
        
        # def initialize(name, pos, elo=1000, early_game=33, late_game=33, condition=50, heroes={})
        def initialize(params={})
            # puts params
            @name = params.fetch('name', 'NONE')
            @elo = params.fetch('elo', 1000)
            @pos = params['pos']

            stats = params.fetch('stats', {})
            @early_game = stats.fetch('early_game', 0.33)
            @late_game = stats.fetch('late_game', 0.33)
            @condition = stats.fetch('condition', 0.5)

            @heroes = params.fetch('heroes', {})
        end

        def update_elo(elo_diff)
            @elo += elo_diff
            # @elo
        end

        def main_heroes
            @heroes.keys
        end

        def hero_rate(hero_id)
            @heroes[hero_id.to_s] || 0.33
        end

        def to_s
            "#{@name} (#{elo})"
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
