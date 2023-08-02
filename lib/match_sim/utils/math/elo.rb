module MatchSim
    module Utils
        module ELO
            K = 35  # ELO multiplier

            def calc_elo(elo1, elo2, is_win)
                ea = 1/(1 + 10 ** ((elo2-elo1)/400))
                ra = K * ((is_win ? 1 : 0) - ea)
                return ra
            end
        end
    end
end