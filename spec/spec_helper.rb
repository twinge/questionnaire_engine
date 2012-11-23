require 'simplecov'
if ENV["COVERAGE"]
  SimpleCov.start 'rails' do
    add_filter 'vendor'
  end
end

ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../dummy/config/environment.rb", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'factory_girl_rails'
require 'database_cleaner'

ENGINE_RAILS_ROOT = File.join( File.dirname(__FILE__), '../' )
Dir[File.join(ENGINE_RAILS_ROOT,"spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|

  config.color_enabled = true
  config.include FactoryGirl::Syntax::Methods

  # Remove models from database before and after test suite is run
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = true

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end