module MatchSim
    module Utils
        module Difference
            def calc_difference(num1, num2)
                # Returns chance of num1 prob
                diff = num1 - num2
                per = diff / [num1, num2].max * 0.5
                return 0.5 - per
            end
        end
    end
end