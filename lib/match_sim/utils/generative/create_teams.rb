module MatchSim
    module Utils
        module Generative
            module Teams
                def get_main_teams()
                    team1 = Team.new('ЯВМЕ', [Player.new('Илья', 1, 1250, [113]), Player.new('Гоша', 2, 1261, [13, 17, 106, 126]), Player.new('Максим', 3, 850, [19, 36]), Player.new('Артем', 4, 1025, [123, 97]), Player.new('Нихад', 5, 400)])
                    team2 = Team.new('Team Spirit', [Player.new('Yatoro', 1, 957, [12, 18, 109, 6]), Player.new('Larl', 2, 448, [106]), Player.new('Collapse', 3, 890, [16, 98, 97]), Player.new('Mira', 4, 551, [19, 20]), Player.new('Miposhka', 5, 2223, [3, 14])])
                    team3 = Team.new('BetBoom Team', [Player.new('Nightfall', 1, 1000), Player.new('gpk', 2, 1000), Player.new('Pure', 3, 1000), Player.new('Save', 4, 400), Player.new('TORONTOTOKYO', 5, 1000)])
                    team4 = Team.new('9Pandas', [Player.new('Пивная Сися', 1, 700), Player.new('StoneBank', 2, 1300), Player.new('yuragi', 3, 953), Player.new('Antares', 4, 200), Player.new('Solo', 5, 1100)])
                    team5 = Team.new('B8', [Player.new('Никита', 1, 1160, [105]), Player.new('Dendi', 2, 1300, [13, 39, 11, 97, 46]), Player.new('Funn1k', 3, 1300), Player.new('Immersion', 4, 500), Player.new('Lodine', 5, 1000)])
                    team6 = Team.new('PSG.LGD', [Player.new('shiro', 1, 816, [10]), Player.new('NothingToSay', 2, 1179, [106, 13, 23, 126]), Player.new('niu', 3, 381, [129]), Player.new('planet', 4, 835, [86, 110, 9]), Player.new('WhyouSm1Le', 5, 2181, [111, 85, 103, 86, 50])])
                    team7 = Team.new('Team Liquid', [Player.new('m1CKe', 1, 1391), Player.new('Nisha', 2, 196), Player.new('zai', 3, 2428, [33, 38, 16, 51, 53]), Player.new('1332', 4, 200, [28]), Player.new('Insania', 5, 1473, [5, 85, 90])])
                    team8 = Team.new('OG', [Player.new('yuragi', 1, 953), Player.new('bzm', 2, 457), Player.new('DM', 3, 855), Player.new('Taiga', 4, 1330), Player.new('Chu', 5, 994)])
                    team9 = Team.new('Virtus.pro', [Player.new('Kiritych', 1, 887), Player.new('squad1x', 2, 517), Player.new('Noticed', 3, 559), Player.new('sayuw', 4, 1032), Player.new('Fng', 5, 2575)])
                    team10 = Team.new('Alliance', [Player.new('charlie', 1, 1058), Player.new('ChYuaN', 2, 981), Player.new('s4', 3, 2419), Player.new('ponlo', 4, 674), Player.new('Handsken', 5, 1859)])

                    teams = [team1, team2, team3, team4, team5, team6, team7, team8, team9, team10]

                    return teams
                end
            end
        end
    end
end
