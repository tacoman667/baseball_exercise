FactoryGirl.define do
  factory :stat_processor do    
    trait :with_players do
      after(:build) do |p|
        p.read_players('data/Master-small.csv')
      end
    end

    trait :with_batting_stats do
      after(:build) do |p|
        p.read_batting_stats('data/Batting-07-12.csv')
      end
    end
  end

  factory :player do
    sequence(:playerid)
    birthyear '1/1/1991'
    namefirst 'Foo'
    namelast 'Bar'
    league 'NL'
  end

  factory :batting_stats do
    yearid 2008
    league 'NL'
    teamid 'HOU'
    g 34
    ab 55
    r 10
    h 17
    hr 5
    two_b 0
    three_b 2
    rbi 5
    sb 5
    cs 2
  end
end