source 'https://rubygems.org'
# it literally complained about not sourcing gemfile :-|

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'




# gem 'rails-api'
gem 'factory_girl_rails'
gem 'faker' #for seed file

group :development, :test do
	gem 'rspec-rails'

	gem 'spring-commands-rspec'

	gem 'pry'
	gem 'pry-rescue'
	gem 'pry-rails'
	

	gem 'dotenv-rails'

	gem 'sqlite3'
end

gem 'rspec_api_documentation'
gem 'apitome', git: 'git://github.com/modeset/apitome.git' #from master, because otherwise gsub error. makes rspec_api_documentation prettier. 
# not git@github.com:modeset/apitome.git because http://stackoverflow.com/a/11558814/3192470

group :development do
	gem 'spring' # Spring speeds up development by keeping your application running in the background.
	
	gem 'railroady' # RailRoady generates Rails 3/4 model (ActiveRecord, Mongoid, Datamapper) and controller UML diagrams. rake diagram:all
end

group :test do
	gem 'airborne' #expect_json
	gem 'database_cleaner'

	gem 'selenium-webdriver'
	gem 'capybara'
end

group :production do
	gem 'rails_12factor' # to enable features such as static asset serving and logging on Heroku please add rails_12factor gem to your Gemfile.
	gem 'pg'
	gem 'uglifier'

	gem 'puma'
	gem 'rack-cors', :require => 'rack/cors' #allow cross-origin requests in production (js is on another server)
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


gem 'active_model_serializers', '~>0.10.0.rc4'


# gem 'twilio-ruby' #not twilio, smslane
# gem 'phonelib' # validates phone numbers
gem 'smslane'

gem 'offsite_payments'


gem 'virtus' #for FormModel

# if you require 'sinatra' you get the DSL extended to Object
gem 'sinatra', :require => nil

ruby '2.2.1'


