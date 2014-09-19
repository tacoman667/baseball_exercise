class StatProcessor
  require 'CSV'

  attr_accessor :players_table, :leagues

  def read_players(file_name)
    @players_table = Hash.new
    @leagues = []
    csv = CSV.new(File.open(file_name), headers: true, header_converters: :symbol, converters: :numeric)
    csv.each do |entry|
      unless entry[:playerid].blank?
        @players_table[entry[:playerid]] = Player.new(entry)
      else
        # log to a file or something
        # p "Missing playerid and cannot record data."
      end
    end
    csv = nil
  end

  def read_batting_stats(file_name)
    if @players_table.nil?
      raise 'read_players must be called first in order to apply batting stats to players.'
    end
    csv = CSV.new(File.open(file_name), headers: true, header_converters: :symbol, converters: :numeric)
    csv.each do |entry|
      @leagues << entry[:league] unless leagues.include? entry[:league]
      player = @players_table[entry[:playerid]]
      player.league = entry[:league]
      player.batting_stats << BattingStats.new(entry)
    end
    csv = nil
  end

  def actual_players
    @players_table.collect{|p| p[1]}
  end

  def players_for_year(year)
    actual_players.reject {|player| player.stats_for_year(year).nil? }
  end

  def players_with_at_bats(at_bats, years)
    players = []
    years.each do |year|
      players = players | actual_players.reject do |player|
        stat = player.stats_for_year(year)
        stat.nil? || stat.ab.to_f < at_bats
      end
    end
    players.uniq {|player| player.playerid}
  end

  def players_on_team(team, year)
    actual_players.reject do |player| 
      stats = player.stats_for_year(year)
      stats.nil? || stats.teamid != team
    end
  end

  def players_for_league(league, year)
    players_for_year(year).reject {|player| player.league != league}
  end

  def player_with_most_improved_batting_average(years, at_bats=0)
    players = players_with_at_bats(at_bats, years)
    players.each do |player|
      averages = []
      years.each do |year|
        averages << player.batting_average(year)
      end
      last_average = 0.0
      averages.map do |avg|
        if avg < last_average
          player.batting_average_improved_by -= avg
        else
          player.batting_average_improved_by += avg
        end
      end
    end
    players.max_by(&:batting_average_improved_by)
  end

  def player_with_most_home_runs(year, players_to_look_though)
    players_to_look_though.max_by {|player| player.stats_for_year(year).hr }
  end

  def player_with_most_rbis(year, players_to_look_though)
    players_to_look_though.max_by {|player| player.stats_for_year(year).rbi }
  end

  def player_with_highest_batting_average(year, players_to_look_though, at_bats=0)
    players = players_to_look_though.reject {|player| player.stats_for_year(year).ab < at_bats}
    players.max_by {|player| player.batting_average(year) }
  end

  def triple_crown_winners(year)
    result = ''
    @leagues.each do |league|
      players = players_for_league(league, year)
      arr = [player_with_most_home_runs(year, players), player_with_most_rbis(year, players), player_with_highest_batting_average(year, players, 400)]
      same_person = arr.collect{|p| p.playerid}.uniq.count == 1
      # arr.each {|player| p "league: #{player.league}: #{player.playerid}: #{player.namefirst} #{player.namelast}"}
      if same_person
        player = arr[0]
        result += "league: #{player.league}: #{player.namefirst} #{player.namelast}\n"
      end
    end

    if result.blank?
      return '(No Winner)'
    else
      return result
    end
  end
end
