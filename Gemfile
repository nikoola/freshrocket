source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'


gem 'rails-api'

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'guard-rspec'
  gem 'spring-commands-rspec'
  gem 'vcr'

  gem 'pry'
  gem 'pry-rescue'
end

group :development do

	gem 'better_errors'
	gem 'binding_of_caller' #for better errors console
	gem 'pry-rails'

	
	gem 'spring' # Spring speeds up development by keeping your application running in the background.
  
  gem 'railroady' #RailRoady generates Rails 3/4 model (ActiveRecord, Mongoid, Datamapper) and controller UML diagrams. rake diagram:all
end

group :test do
  gem 'airborne'
  gem 'database_cleaner'
end




gem 'paperclip'


gem 'devise'
gem 'devise_token_auth' # Token based authentication for Rails JSON APIs
gem 'omniauth' # required for devise_token_auth