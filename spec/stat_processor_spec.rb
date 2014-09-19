require 'spec_helper.rb'

describe 'StatProcessor' do 
  let(:processor) { build(:stat_processor, :with_players, :with_batting_stats) }

  before(:each) do
    @players = [
      build(:player, playerid: 'foobar1', namefirst: 'foo', namelast: 'bar', 
            batting_stats: [build(:batting_stats, hr: 100, rbi: 100, h: 100, ab: 100)]),
      build(:player, batting_stats: [build(:batting_stats)])
    ]
  end

  it 'should not be nil' do
    expect(processor).to_not be_nil
  end

  it 'should read players file' do
    expect(processor.actual_players.count).to be > 5
    expect(processor.actual_players.first.namefirst).to eq('Hank')
  end

  it 'should read player batting stats' do
    expect(processor.players_table['aardsda01'].batting_stats.first.league).to eq('AL')
  end

  it 'should get only players with at least 200 at bats' do
    expect(processor.players_with_at_bats(200, 2009..2010).count).to eq(401)
  end

  it 'should get players for team OAK in year 2007' do
    expect(processor.players_on_team('OAK', 2007).count).to eq(48)
  end

  it 'should return players for league' do
    expect(processor.players_for_league('NL', 2008).count).to eq(694)
  end

  it 'should get player with most improved batting average from 2009 to 2010' do
    players = processor.actual_players
    expect(processor.player_with_most_improved_batting_average(2009..2010, 200).playerid).to eq('mauerjo01')
  end

  it 'should get player with most improved batting average from 2010 to 2011' do
    players = processor.actual_players
    expect(processor.player_with_most_improved_batting_average(2010..2011, 200).playerid).to eq('cabremi01')
  end

  it 'should get player with most home runs in 2008' do
    expect(processor.player_with_most_home_runs(2008, @players).playerid).to eq('foobar1')
  end

  it 'should get player with the most rbis in 2008' do
    expect(processor.player_with_most_rbis(2008, @players).playerid).to eq('foobar1')
  end

  it 'should get player with the highest batting average in 2008' do
    expect(processor.player_with_highest_batting_average(2008, @players).playerid).to eq('foobar1')
  end

  it 'should show who triple crown winner is for 2012' do
    expect(processor.triple_crown_winners(2012)).to eq('NL: Miguel Cabrera')
  end
end