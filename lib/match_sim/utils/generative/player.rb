module MatchSim
  module Utils
    module Generative
      module Player
        def self.build(team_name, player_name)
          file = File.open "lib/src/json/teams/#{team_name}/#{player_name}.json"
          data = JSON.load file
          file.close

          # MatchSim::Team.new(data)
          MatchSim::Player.new(data)
        end
      end
    end
  end
end
