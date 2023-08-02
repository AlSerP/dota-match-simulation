module MatchSim
    class PlayerStat
        include MatchSim::Utils::ELO
        include MatchSim::Utils::Winrates
        include MatchSim::Utils::Heroes
        include MatchSim::Utils::Normalization

        POS_COEF = {
            1 => 1.2,
            2 => 1.2,
            3 => 1,
            4 => 0.8,
            5 => 0.8
        }
        CREEP_GOLD = 43

        attr_reader :coef, :player, :hero, :pos

        def initialize(player, opponent_team, hero=nil)
            @player = player
    
            @kills = 0
            @assists = 0
            @deaths = 0
            
            @pos = player.pos
            @hero = hero
    
            @gold = 0.0
            @creeps = 0
    
            opponent_sum_elo = 0
            opponent_team.each {|player| opponent_sum_elo += player.elo }
            opponent_mean_elo = opponent_sum_elo.to_f / 2 
    
            @coef = player.elo.to_f / opponent_mean_elo * 0.5
            @elo_term = nil 
        end
        def kill(target)
            @kills += 1
            target.die
            money_prize = target.get_cost * 0.5 # Get 1/2 of enemy kill prize
            give_gold(money_prize)
            return @kills
        end
        def get_main_heroes
            return @player.get_main_heroes
        end
        def die
            @deaths += 1
            lost_gold = @gold * 0.02 
            remove_gold(lost_gold)
            return @deaths
        end
        def get_cost
            return 125 + (@gold * 0.08)
        end
        def assisted (target)
            @assists += 1
            if [4, 5].include? @pos
                money_prize = target.get_cost * 0.33  # Get 1/3 of enemy kill prize for suppor
            else
                money_prize = target.get_cost * 0.1  # Get 1/10 of enemy kill prize for cores
            end  
            give_gold(money_prize) 
            return @assists
        end
        def give_gold(gold)
            @gold += gold
            return @gold
        end
        def remove_gold(gold)
            @gold += gold
            return @gold
        end
        def kill_creeps(num)
            @creeps += num
            sum_gold = num * CREEP_GOLD
            give_gold(sum_gold)
    
            return @creeps
        end
        def to_s
            "#{@player.name} | #{get_hero_name_by_id(@hero)}  #{@kills}/#{@deaths}/#{@assists} | CREEPS=#{@creeps}| #{@gold.round()}$"
        end

        def to_json(*options)
            as_json(*options).to_json(*options)
        end

        def pick(teammates_pick, opponent_pick, bans)
            best_hero = nil
            best_rate = -1.0
            prefer_picks = @player.get_main_heroes.map(&:clone)
            prefer_picks.delete(prefer_picks.sample(prefer_picks.length / 2))  # Make some random shit
            prefer_picks.each do |player_hero|
                # The hero can't be repeated
                next if teammates_pick.include?(player_hero) or opponent_pick.include?(player_hero) or bans.include?(player_hero)
    
                vs_mean_rate = 1.0
                opponent_pick.each do |hero|
                    vs_mean_rate *= get_winrates[player_hero.to_s][hero.to_s]
                end
                if vs_mean_rate > best_rate
                    best_rate = vs_mean_rate
                    best_hero = player_hero
                end
            end
    
            # Give a Random hero, if he wasn't taken
            if best_hero == nil
                heroes = get_heroes().keys
                best_hero = heroes.sample.to_i
                while (teammates_pick.include?(best_hero) or opponent_pick.include?(best_hero) or bans.include?(best_hero))
                    best_hero = heroes.sample.to_i
                end
            end
            set_hero(best_hero)
            teammates_pick.append(best_hero)
            return teammates_pick
        end
        def set_hero(hero)
            @hero = hero
        end
        def get_pos_coef
            return @coef * POS_COEF[@pos]
        end
    
        def get_stat_coef
            if @pos == 1 or @pos == 2
                # Core stat
                pos_modif = (@kills * 1.5 + @assists * 0.5 - @deaths * 2.5)
            elsif @pos == 3
                # Tank stat
                pos_modif = (@kills * 1 + @assists * 0.5 - @deaths * 1.5)
            else 
                # Core stat
                pos_modif = (@kills * 0.5 + @assists * 1 - @deaths * 2)
            end
            return pos_modif
        end
    
        def summarize(is_win, min_score, max_score, mean_opponent_elo)
            if is_win
                @elo_term = calc_elo(@player.elo, mean_opponent_elo, is_win) * (normalize(get_stat_coef, min_score, max_score) - 0.2)
                @player.update_elo(@elo_term)
            else
                @elo_term = calc_elo(@player.elo, mean_opponent_elo, is_win) * (0.7 - normalize(get_stat_coef, min_score, max_score))
                @player.update_elo(@elo_term)
            end
        end

        def as_json(options={})
            {
                player: @player.as_json,

                kills: @kills,
                deaths: @deaths,
                assists: @assists,

                hero: @hero,
                gold: @gold.round(),
                creeps: @creeps, 

                elo: @elo_term
            }
        end

        def to_json(*options)
            as_json(*options).to_json(*options)
        end
    end
end