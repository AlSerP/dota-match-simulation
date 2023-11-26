module MatchSim
  module Utils
    module Generative
      module Team
        def self.build(team_name)
          players = []

          Dir["lib/src/json/teams/#{team_name}/*"].each do |player_path|
            file = File.open player_path
            data = JSON.load file
            file.close

            players << MatchSim::Player.new(data)
          end

          MatchSim::Team.new(team_name, players)
          # file = File.open "lib/src/json/teams/#{team_name}/#{player_name}.json"
          # data = JSON.load file
          # file.close

          # MatchSim::Team.new(data)
          # MatchSim::Player.new(data)
        end
      end
    end
  end
end
