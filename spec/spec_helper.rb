require 'factory_girl_rails'

proj_root = Dir.getwd

Dir.glob('lib/**/*.rb').each { |f| require "#{proj_root}/#{f}" }
Dir.glob('spec/support/**/*.rb').each { |f| require "#{proj_root}/#{f}" }

RSpec.configure do |config|

  # issue with spring and factorygirl
  config.before(:all) do
    FactoryGirl.reload
  end

  config.include FactoryGirl::Syntax::Methods

  config.filter_run_excluding false_positive: true unless ENV['ALL']
  config.order = 'random'

  config.before(:suite) do
    
  end

  config.before(:each) do

  end

  config.after(:each) do

  end
end