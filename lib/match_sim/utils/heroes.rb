module MatchSim
    module Utils
        module Heroes
            PATH = 'lib/src/json/heroes.json'
            @heroes = nil

            def id_to_names(team)
                names = []
                team.each { |hero| names.append(get_hero_name_by_id(hero)) }
                return names
            end

            def get_hero_name_by_id(hero)
                if @heroes.nil?
                    get_heroes()
                end
                return @heroes[hero.to_s]['name']
            end

            def get_heroes
                if @heroes.nil?
                    @heroes = JSON.parse File.open(PATH).read
                end
                
                return @heroes
            end
        end
    end
end