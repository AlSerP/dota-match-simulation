module MatchSim
    class Match
        require 'json'

        include MatchSim::Utils::Heroes
        include MatchSim::Utils::Winrates
        include MatchSim::Utils::Difference
        
        RANDOM = Random.new

        attr_reader :radiant, :dire

        EARLY_STAGE = 15
        MIDDLE_STAGE = 35
        LATE_STAGE = 80

        def initialize(radiant, dire)
            @radiant = radiant
            @dire = dire
            @report = {}

            @game_stage = nil
        end
        
        def calc_team_coefficient(team)
            team_c = 1
            team.each do |player| 
                team_c += player.coef
            end
            return team_c
        end

        def simulate(console=false)
            # Preparation
            radiant = @radiant.create_match_stat(@dire)
            dire = @dire.create_match_stat(@radiant)
            
            picks = pick_heroes(radiant, dire)
        
            radiant_win = false
            radiant_c = calc_team_coefficient(radiant)
            dire_c = calc_team_coefficient(dire)
        
            result = RANDOM.rand
            match_time = [RANDOM.rand(20..65), RANDOM.rand(0..59)] # Minutes:Seconds
        
            score = [0, 0]
            for minute in 0..match_time[0]
                sim_minute!(radiant, dire, minute, score)
            end
            if score[0] == 0 and score[1] == 0
                return sim_match(@radiant, @dire)
            end
        
            score_c = (score[0] == 0 or score[1] == 0) ? 1 : score[1].to_f / score[0]
            teams_c = dire_c / radiant_c
            # match_coef = score_c * teams_c * 0.5  # Probability of radiant win
            match_coef = score_c * 0.5  # Probability of radiant win

            puts "MATCH COEF #{match_coef}"

            radiant_win = true if result > match_coef
        
            # Elo results
            max_stat = -200
            min_stat = 200
            for i in 0..4 do
                radiant_player_stat = radiant[i].get_stat_coef
                max_stat = radiant_player_stat if radiant_player_stat > max_stat
                min_stat = radiant_player_stat if radiant_player_stat < min_stat
        
                dire_player_stat = dire[i].get_stat_coef
                max_stat = dire_player_stat if dire_player_stat > max_stat
                min_stat = dire_player_stat if dire_player_stat < min_stat
            end
        
            for i in 0..4 do
                radiant[i].summarize(radiant_win, min_stat, max_stat, @dire.get_mean_elo)
                dire[i].summarize(!radiant_win, min_stat, max_stat, @radiant.get_mean_elo)
            end
            
            coefs = { result: result, match_coef: match_coef, score_coef: score_c, teams_coef: teams_c }
            picks_report = { radiant: picks[0], dire: picks[1], bans: picks[2] }
            @report = { radiant_name: @radiant.name, dire_name: @dire.name, score: score, radiant_win: radiant_win, time: match_time, radiant_stat: radiant, dire_stat: dire, picks: picks_report, coefs: coefs }

            if console
                print_report
            end

            # puts @report.to_json
            return @report
        end

        private

        MINUTE_GOLD = 101.4
        POS_CREEP_CHANCE = [0.55, 0.45, 0.3, 0.1, 0.1]

        FIGHT_TYPE_PROB = {
            0 => {
                EARLY_STAGE => 0.2,
                MIDDLE_STAGE => 0.1,
                LATE_STAGE => 0.05
            },
            1 => {
                EARLY_STAGE => 0.6,
                MIDDLE_STAGE => 0.2,
                LATE_STAGE => 0.20
            },
            2 => {
                EARLY_STAGE => 0.8,
                MIDDLE_STAGE => 0.5,
                LATE_STAGE => 0.4
            },
            3 => {
                EARLY_STAGE => 1.0,
                MIDDLE_STAGE => 0.7,
                LATE_STAGE => 0.65
            },
            4 => {
                EARLY_STAGE => 1.0,
                MIDDLE_STAGE => 0.9,
                LATE_STAGE => 0.75
            },
            5 => {
                EARLY_STAGE => 1.0,
                MIDDLE_STAGE => 1.0,
                LATE_STAGE => 1.0
            }
        }

        def sim_minute!(radiant, dire, minute, score)
            def sim_creeps(radiant, dire, dead)
                def sim_player_creeps(player)
                    creeps_per_minute = 12
                    creeps_count = 0
                    kill_chance = POS_CREEP_CHANCE[player.pos - 1]
                    for i in 1..creeps_per_minute
                        if RANDOM.rand() >= 1 - kill_chance
                            creeps_count += 1
                        end
                    end
                    player.kill_creeps(creeps_count)
                    return creeps_count
                end
        
                for i in 0..4
                    if not dead.include? radiant[i]
                        sim_player_creeps(radiant[i])
                    end
                    if not dead.include? dire[i]
                        sim_player_creeps(dire[i])
                    end
                end
        
                return [radiant, dire]
            end
            
            def get_fighters(radiant, dire, minute)
                def decide_fight_type(minute)
                    @game_stage = EARLY_STAGE
                    if minute <= EARLY_STAGE
                        @game_stage = EARLY_STAGE
                    elsif minute <= MIDDLE_STAGE
                        @game_stage = MIDDLE_STAGE
                    else
                        @game_stage = LATE_STAGE
                    end
                
                    res = RANDOM.rand(0..5)
                    for i in 0..5 do
                        if res <= FIGHT_TYPE_PROB[i][@game_stage]
                            return i
                        end
                    end
                    return 0
                end
        
                fight_type = decide_fight_type(minute)
        
                fighters_r = []
                fighters_d = []
                i = 0
                while i < fight_type do
                    player_radiant = RANDOM.rand(0..4)
                    while fighters_r.include?(player_radiant)
                        player_radiant = RANDOM.rand(0..4)
                    end
                    fighters_r.append(player_radiant)
        
                    player_dire = RANDOM.rand(0..4)
                    while fighters_d.include?(player_dire)
                        player_dire = RANDOM.rand(0..4)
                    end
                    fighters_d.append(player_dire)
        
                    i += 1
                end
        
                return [fighters_r, fighters_d]
            end
        
            def give_minute_gold(radiant, dire)
                for i in 0..4
                    radiant[i].give_gold(MINUTE_GOLD)
                    dire[i].give_gold(MINUTE_GOLD)
                end
            end
        
            def get_fighters_coef(radiant, dire, minute)
                fighters_r, fighters_d = get_fighters(radiant, dire, minute)
        
                fighters_r_coef = []
                fighters_d_coef = []
        
                for i in 0..(fighters_r.length - 1)
                    fighters_r_coef[i] = radiant[fighters_r[i]]
                    fighters_d_coef[i] = dire[fighters_d[i]]
                end
        
                return [fighters_r_coef, fighters_d_coef]
            end
            
            def sim_fight(radiant, dire)
                def player_vs_player_fight(player1, player2)
                    result = RANDOM.rand
                
                    player1_winrate = get_winrates[player1.hero.to_s][player2.hero.to_s] ? get_winrates[player1.hero.to_s][player2.hero.to_s] + 0.5 : 1
                    player2_winrate = get_winrates[player2.hero.to_s][player1.hero.to_s] ? get_winrates[player2.hero.to_s][player1.hero.to_s] + 0.5 : 1
                    
                    # Calc chance with current hero
                    player1_winrate *= player1.hero_rate player1.hero ** 0.5 # TODO: Исправить коэффициент
                    player2_winrate *= player2.hero_rate player2.hero ** 0.5

                    player1_winrate *= player1.condition
                    player2_winrate *= player2.condition
                    
                    player1_winrate *= player1.get_stage_coef(@game_stage)
                    player2_winrate *= player2.get_stage_coef(@game_stage)

                    player1_custom_score = player1.get_pos_coef * player1_winrate
                    player2_custom_score = player2.get_pos_coef * player2_winrate
                
                    player1_win = result > calc_difference(player1_custom_score, player2_custom_score)
                    return player1_win
                end
                score = [0, 0]
                dead = []
                for player_r_index in 0..(radiant.length-1) do
                    player_radiant = radiant[player_r_index]
                    for player_d_index in 0..(dire.length-1) do
                        player_dire = dire[player_d_index]
                        
                        if player_dire != -1
                            result = RANDOM.rand
                            if player_vs_player_fight(player_radiant, player_dire)
                                score[0] += 1
                                dead.push(player_dire)
                                dire[player_d_index] = -1
                                player_radiant.kill(player_dire)
                                radiant.each { |player| player.assisted(player_dire) if player != -1 and player != player_radiant }
                            else
                                score[1] += 1
                                dead.push(player_radiant)
                                radiant[player_r_index] = -1
                                player_dire.kill(player_radiant)
                                dire.each { |player| player.assisted(player_radiant) if player != -1 and player != player_dire }
                                break
                            end
                        end
                    end
                end
                return [score, dead]
            end

            give_minute_gold(radiant, dire)
            fighters_r_coef, fighters_d_coef = get_fighters_coef(radiant, dire, minute)
            res, dead = sim_fight(fighters_r_coef, fighters_d_coef)
            score[0] += res[0]
            score[1] += res[1]
            sim_creeps(radiant, dire, dead)
            # puts("Munite #{minute} | Teams: #{fighters_r} - #{fighters_d} | #{res}")
        end

        def print_report
            p @report[:coefs]
            puts ("Radiant pick - #{@report[:picks][:radiant]} - #{id_to_names(@report[:picks][:radiant])}")
            puts ("Dire pick - #{@report[:picks][:dire]} - #{id_to_names(@report[:picks][:dire])}")
            puts ("Bans - #{id_to_names(@report[:picks][:bans])}")
            puts("Score - #{@report[:score][0]}:#{@report[:score][1]} " + (@report[:radiant_win] ? '(Radiant win!)' : '(Dire win!)'))
            puts("per #{@report[:time][0]}:#{@report[:time][1]} mins")
            puts("Radiant-----------#{@report[:radiant_name]}")
            puts @report[:radiant_stat]
            
            puts("Dire-----------#{@report[:dire_name]}")
            puts @report[:dire_stat]

            puts("Match result #{@report[:coefs][:result]} with match coefficient #{@report[:coefs][:match_coef]}, score coefficient #{@report[:coefs][:score_coef]}, teams coefficient #{@report[:coefs][:teams_coef]}")
            puts('=========================')
        end

        def pick_heroes(team1, team2)
            team1_pick = []
            team2_pick = []
            bans = []
            heroes = get_heroes.keys
            for i in 0..9 do
                hero = heroes.sample.to_i
                while bans.include?(hero)
                    hero = heroes.sample.to_i
                end
                bans.append(hero)
            end
            for i in 0..4 do
                team1[4 - i].pick(team1_pick, team2_pick, bans)
                team2[4 - i].pick(team2_pick, team1_pick, bans)
            end
        
            return [team1_pick, team2_pick, bans]
        end
    end
end