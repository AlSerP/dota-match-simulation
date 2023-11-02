module MatchSim
  class TeamStat
    attr_reader :team, :score

    def initialize(team)
      @team = team
      @wins = 0
      @looses = 0
      @score = 0
      @matches = 0
    end

    def update!(is_win)
      is_win ? win : loose
    end

    def to_s
      "#{@team.to_s.ljust(40)} #{@matches.to_s.rjust(4)} #{@wins.to_s.rjust(4)} #{@score.to_s.rjust(4)} #{(@wins.to_f/@matches * 100).round(1)}%"
    end

    def to_h
      {
        wins: @wins,
        looses: @looses,
        matches: @matches,
        score: @score,
        team: @team.to_h
      }
    end

    def to_json(*options)
      to_h.to_json(*options)
    end

    private

    def win
      @matches += 1
      @wins += 1
      @score += 3
    end

    def draw
      @matches += 1
      @score += 1
    end

    def loose
      @matches += 1
      @looses += 1
      @score
    end
  end
end