module MatchSim
  class League
    def initialize(teams, match_num = 1)
      @teams = teams
      @table = MatchSim::Table.new teams
      @match_num = match_num
      @matches = []
    end

    def sim_match(radiant, dire)
      match = MatchSim::Match.new radiant, dire

      results = match.simulate

      @matches << { match: match, results: results }
      @table.update! results
    end

    def sim
      @match_num.times do
        (0...(@teams.size)).each do |i|
          ((i + 1)...(@teams.size)).each do |j|
            if @teams[i] != @teams[j]
              sim_match(@teams[i], @teams[j])
            else
              puts 'SAME TEAM'
            end
          end
        end
      end

      self.to_s
    end

    def to_s
      @table.to_s
    end
  end
end
