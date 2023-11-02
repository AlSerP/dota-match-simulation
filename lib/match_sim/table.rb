module MatchSim
  class Table
    def initialize(teams)
      @stats = self.class.create_stats teams
    end

    def update!(match_results)
      score_radiant = find_stat(match_results[:radiant_name])&.update!(match_results[:radiant_win])
      score_dire = find_stat(match_results[:dire_name])&.update!(!match_results[:radiant_win])

      sort!
      [score_radiant, score_dire]
    end

    def sort!
      @stats.sort_by! { |stat| -stat.score }
    end

    def find_stat(team_name)
      @stats.each do |stat|
        return stat if stat.team.name == team_name
      end

      nil
    end

    def to_s
      s = "#{'№'.ljust(4)} #{'Team (elo)'.ljust(40)} #{'mtch'.rjust(4)} #{'wins'.rjust(4)} #{'scr'.rjust(4)}\n"

      (0...(@stats.size)).each do |i|
        s << "#{((i + 1).to_s << '.').ljust(4)}" << @stats[i].to_s << "\n"
      end

      s
    end

    def self.create_stats(teams)
      stats = []

      teams.each do |team|
        stats.push TeamStat.new(team)
      end

      stats
    end

    # def stats

    # end
  end
end
