RSpec.configure do |config|


  # {except: ['settings']} because it's a singleton class, and we define it's first row on load.
  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation, {except: ['settings']}
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation, {except: ['settings']}
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end