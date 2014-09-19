require 'spec_helper.rb'

describe 'Player' do 
  let!(:player) { build(:player) }
  let!(:batting_stats) { build(:batting_stats) }

  it 'should not be nil' do
    expect(player).to_not be_nil
  end

  it 'should initialize' do
    new_player = Player.new(playerid: 1, birthyear: Date.today, namefirst: 'foo', namelast: 'bar')
    expect(new_player).to_not be_nil
    expect(new_player.namefirst).to eq('foo')
  end

  it 'can init without params' do
    expect(Player.new).to_not be_nil
  end

  it 'should get stat for year 2008' do
    player.batting_stats << batting_stats
    expect(player.stats_for_year(2008)).to_not be_nil
  end

  it 'should give nil if no stat for year' do
    player.batting_stats << batting_stats
    expect(player.stats_for_year(2010)).to be_nil
  end

  it 'should sanitize results of NaN' do
    expect(player.sanitize(0.fdiv(0))).to eq(0.0)
  end

  it 'should sanitize results of Infinity' do
    expect(player.sanitize(17.fdiv(0))).to eq(0.0)
  end

  context 'when getting batting average' do
    it 'should return 0.0 when no stats for year are found' do
      expect(player.batting_average(2008)).to eq(0.0)
    end

    it 'should get batting average' do
      batting_stats.h = 11
      batting_stats.ab = 35
      player.batting_stats << batting_stats
      expect(player.batting_average(2008)).to eq(0.314)
    end

    it 'should return 0.0 if result was Infinity' do
      batting_stats.ab = 0
      player.batting_stats << batting_stats
      expect(player.batting_average(2008)).to eq(0.0)
    end

    it 'should return 0.0 if result was NaN' do
      batting_stats.h = 0
      player.batting_stats << batting_stats
      expect(player.batting_average(2008)).to eq(0.0)
    end
  end

  context 'when getting slugging percentage' do
    it 'should return 0.0 when no stats for year are found' do
      expect(player.slugging_percentage(2008)).to eq(0.0)
    end

    it 'should get slugging percentage' do
      batting_stats.h = 1
      batting_stats.two_b = 2
      batting_stats.three_b = 3
      batting_stats.hr = 4
      batting_stats.ab = 10

      player.batting_stats << batting_stats
      expect(player.slugging_percentage(2008)).to eq(2.1)
    end

    it 'should return 0.0 if result was Infinity' do
      batting_stats.ab = 0
      player.batting_stats << batting_stats
      expect(player.slugging_percentage(2008)).to eq(0.0)
    end

    it 'should return 0.0 if result was NaN' do
      batting_stats.h = 0
      batting_stats.two_b = 0
      batting_stats.three_b = 0
      batting_stats.hr = 0
      player.batting_stats << batting_stats
      expect(player.slugging_percentage(2008)).to eq(0.0)
    end
  end
end