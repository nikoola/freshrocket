
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'




# gem 'rails-api'

group :development, :test do
	gem 'rspec-rails'
	gem 'factory_girl_rails'

	gem 'spring-commands-rspec'

	gem 'pry'
	gem 'pry-rescue'
	gem 'pry-rails'
	
	gem 'rspec_api_documentation'
	gem 'apitome', git: 'git@github.com:modeset/apitome.git' #from master, because otherwise gsub error
	gem 'faker'

	gem 'dotenv-rails'

	gem 'sqlite3'
end

group :development do
	gem 'better_errors'
	gem 'binding_of_caller' # for better errors console

	
	gem 'spring' # Spring speeds up development by keeping your application running in the background.
	
	gem 'railroady' # RailRoady generates Rails 3/4 model (ActiveRecord, Mongoid, Datamapper) and controller UML diagrams. rake diagram:all
end

group :test do
	gem 'airborne' #expect_json
	gem 'database_cleaner'
end

group :production do
	gem 'rails_12factor' # to enable features such as static asset serving and logging on Heroku please add rails_12factor gem to your Gemfile.
	gem 'pg'
end



gem 'carrierwave'
gem 'mini_magick'

# gem 'devise'
gem 'devise_token_auth' # Token based authentication for Rails JSON APIs
gem 'omniauth' # required for devise_token_auth
gem 'omniauth-facebook'


# gem 'regulator' # like pundit, but allows policy namespacing.

gem 'acts-as-taggable-on'

gem 'aasm'
gem 'sidekiq'


gem 'active_model_serializers'


# gem 'twilio-ruby' #not twilio, smslane
gem 'phonelib' # validates phone numbers

gem 'offsite_payments'

gem 'smslane'


ruby '2.2.1'


