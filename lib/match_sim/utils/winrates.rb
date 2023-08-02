module MatchSim
    module Utils
        module Winrates
            require 'json'
            
            PATH = 'lib/src/json/winrates.json'
            @winrates = nil

            def get_winrates
                if @winrates.nil?
                    @winrates = JSON.parse File.open(PATH).read
                end

                return @winrates
            end
        end
    end
end