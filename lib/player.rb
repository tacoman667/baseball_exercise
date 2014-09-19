class Player

  attr_accessor :playerid, :birthyear, :namefirst, :namelast, :batting_stats, 
                :batting_average_improved_by, :league
  
  def initialize(args={})
    @batting_stats = []
    @batting_average_improved_by = 0
    args.each do |arg|
      if arg[1].nil?
        arg[1] = ''
      end
      self.send("#{arg[0]}=", arg[1])
    end
  end

  def stats_for_year(year)
    batting_stats.select { |s| s.yearid == year }.first
  end

  def sanitize(result)
    if result.nan? || result.infinite?
      return 0.0
    else
      return result
    end
  end

  def batting_average(year)
    #  hits / at-bats
    stat = stats_for_year(year)
    if stat.nil?
      return 0.0
    end
    return sanitize(stat.h.fdiv(stat.ab).round(3))
  end

  def slugging_percentage(year)
    # ((Hits – doubles – triples – home runs) + (2 * doubles) + (3 * triples) + (4 * home runs)) / at-bats
    stat = stats_for_year(year)
    if stat.nil?
      return 0.0
    end
    slugging_per = ((stat.h - stat.two_b - stat.three_b - stat.hr) + (2 * stat.two_b) + (3 * stat.three_b) + (4 * stat.hr)).fdiv(stat.ab)
    return sanitize(slugging_per.round(3))
  end
end