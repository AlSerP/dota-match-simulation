module MatchSim
  require 'gruff'

  class League
    def initialize(teams, match_num = 1, name = 'League')
      @teams = teams
      @table = MatchSim::Table.new teams
      @match_num = match_num
      # @matches = []
      @name = name

      @elo_data = {}
    end

    def sim
      log 'START SIMULATION'
      @match_num.times do |t|
        (0...(@teams.size)).each do |i|
          t1 = @teams[i]
          t2 = get_closest_team @teams[i]

          sim_match t1, t2
          # add_elo_data t1
          # add_elo_data t2

          # if @teams[i] != @teams[j]
          #   sim_match(@teams[i], @teams[j])
          #   @elo_data[@teams[i].name] = @elo_data.fetch(@teams[i].name, []).push @teams[i].mean_elo
          #   @elo_data[@teams[j].name] = @elo_data.fetch(@teams[j].name, []).push @teams[j].mean_elo
          # else
          #   log_error 'SAME TEAM'
          # end
        end

        @teams.each { |team| add_elo_data team }

        log "PROGRESS IS #{t + 1}/#{@match_num}"
      end

      log 'SIMULATION ENDED'
      save_plots

      to_s
    end

    def to_s
      @table.to_s
    end

    private

    def add_elo_data(team)
      @elo_data[team.name] = @elo_data.fetch(team.name, []).push team.mean_elo
    end

    def get_closest_team(team)
      closest = nil

      @teams.each do |t|
        next if team == t

        unless closest
          closest = t
          next
        end

        closest = t if (team.mean_elo - t.mean_elo).abs < (team.mean_elo - closest.mean_elo).abs
      end

      closest
    end

    def save_plots
      log 'START CREATING PLOTS'
      g = Gruff::Line.new
      g.title = 'Summary'

      @elo_data.keys.each do |team_name|
        g.data team_name, @elo_data[team_name]

        # g.write("images/#{team_name.downcase}.png")
      end

      log 'WRITING'
      g.write("images/summ.png")
      log 'SAVING COMPLETE'
    end

    def sim_match(radiant, dire)
      match = MatchSim::Match.new radiant, dire

      results = match.simulate

      # @matches << { match: match, results: results }
      @table.update! results
    end

    def log_error(text)
      puts "#{Time.now} -- ERROR -- #{text}"
    end

    def log(text)
      puts "#{Time.now} -- INFO -- #{text}"
    end
  end
end
