module MatchSim
  require 'gruff'
  require 'logger'

  class League
    def initialize(teams, match_num = 1, name = 'League')
      @teams = teams
      @table = MatchSim::Table.new teams
      @match_num = match_num
      # @matches = []
      @name = name
      @logger = Logger.new('log/logfile.log')

      @bugs_counter = 0
      @elo_data = {}
    end

    def sim
      @logger.info "START SIMULATION OF #{@name}"
      pairs_num = @teams.size / 2
      @match_num.times do |round|
        (@teams.size - 1).times do
          (0...pairs_num).each do |i|
            j = (i + round) % pairs_num + pairs_num

            t1 = @teams[i]
            t2 = @teams[j]

            sim_match t1, t2

            add_elo_data t1
            add_elo_data t2

            # add_elo_data t1
            # add_elo_data t2
          end
        end
        @logger.info "PROGRESS IS #{round + 1}/#{@match_num}"
      end

      @logger.info 'SIMULATION ENDED'
      @logger.warn "BAD MATCHES NUMBER: #{@bugs_counter}"
      save_plots

      to_s
    end

    def to_s
      @table.to_s
    end

    private

    def add_elo_data(team)
      # @elo_data[team.name] = @elo_data.fetch(team.name, []).push team.mean_elo
      stat = @table.find_stat team.name
      @elo_data[team.name] = @elo_data.fetch(team.name, []).push(stat.score)
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
      @logger.info 'START CREATING PLOTS'
      g = Gruff::Line.new
      g.title = 'Summary'

      @elo_data.keys.each do |team_name|
        g.data team_name, @elo_data[team_name]

        # g.write("images/#{team_name.downcase}.png")
      end

      @logger.info 'WRITING'
      g.write("images/summ.png")
      @logger.info 'SAVING COMPLETE'
    end

    def sim_match(radiant, dire)
      match = MatchSim::Match.new radiant, dire

      results = match.simulate
      @logger.info "Match #{results[:radiant_name]}#{'(WIN)' if results[:radiant_win]} #{results[:score][0]}:#{results[:score][1]} #{results[:dire_name]}#{'(WIN)' unless results[:radiant_win]} per #{results[:time][0]}:#{results[:time][1]}"
      @bugs_counter += 1 if results[:score][0] < 12 && results[:score][1] < 12
      # @matches << { match: match, results: results }
      @table.update! results
    end
  end
end
