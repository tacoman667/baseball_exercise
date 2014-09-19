class BattingStats
  attr_accessor :yearid, :league, :teamid, :g, :ab, :r, :h, :hr, :two_b, :three_b, :rbi, :sb, :cs
  alias :'2b=' :two_b=
  alias :'2b' :two_b
  alias :'3b=' :three_b=
  alias :'3b' :three_b

  def initialize(args={})
    args.each do |arg|
      prop = "#{arg[0]}="
      if arg[1].nil?
        arg[1] = if ['league', 'teamid'].include?(arg[0]) then '' else 0 end
      end
      if self.respond_to? prop
        self.send(prop, arg[1])
      end
    end
  end
end