module MatchSim
    module Utils
        module Normalization
            def normalize(x, min, max)
                return (x - min) / (max - min)
            end
        end
    end
end