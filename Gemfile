source 'https://rubygems.org'
# it literally complained about not sourcing gemfile :-|

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'


# gem 'rails-api'
gem 'factory_girl_rails', require: false #because of fixtures and seeds.rb
gem 'faker' #for seed file
gem 'rack-cors', :require => 'rack/cors' #allow cross-origin requests in production (js is on another server)
  																				 #needful also at the development due to chrome policy.
group :development, :test do
	gem 'rspec-rails'
	gem 'spring-commands-rspec'
	gem 'byebug'
	gem 'pry'
	gem 'pry-rescue'
	gem 'pry-rails'
	gem 'pry-byebug'
	

	gem 'dotenv-rails'
	

	gem 'sqlite3'

end

gem 'rspec_api_documentation'
gem 'apitome', git: 'git://github.com/modeset/apitome.git' #from master, because otherwise gsub error. makes rspec_api_documentation prettier. 
# not git@github.com:modeset/apitome.git because http://stackoverflow.com/a/11558814/3192470

group :development do
	gem 'spring' # Spring speeds up development by keeping your application running in the background.
	gem 'guard'
	gem 'guard-rspec'
	gem 'railroady' # RailRoady generates Rails 3/4 model (ActiveRecord, Mongoid, Datamapper) and controller UML diagrams. rake diagram:all
end
# gem 'parallel_tests', group: [:development, :test]
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


end



gem 'carrierwave'
gem 'mini_magick'
gem 'carrierwave-base64' #for api upload

# gem 'devise'
gem 'devise_token_auth' # Token based authentication for Rails JSON APIs
gem 'omniauth' # required for devise_token_auth
gem 'omniauth-facebook'


# gem 'regulator' # like pundit, but allows policy namespacing.

gem 'acts-as-taggable-on'
gem 'aasm'


gem 'sidekiq'
gem 'sidekiq-failures'

# gem 'active_model_serializers', '~>0.10.0.rc4'
gem 'active_model_serializers', git: 'https://github.com/brigade/active_model_serializers.git'



# gem 'twilio-ruby' #not twilio, smslane
# gem 'phonelib' # validates phone numbers
# gem 'smslane' #tried but didnt like it, as it said 'template didn't match' when they did

gem 'excon' #msg91 is stupid and doesn't know how to reference gems from gemspec
gem 'msg91', :github => 'shyammohankanojia/msg91-ruby'


gem 'offsite_payments'


gem 'virtus' #for FormModel

# if you require 'sinatra' you get the DSL extended to Object
gem 'sinatra', :require => nil












gem 'fog', require: 'fog/aws' # S3 pic storage

gem 'wkhtmltopdf-binary', group: [:development, :test]
gem 'wkhtmltopdf-heroku', group: :production
gem 'wicked_pdf'

gem "letter_opener",      group: :development


gem 'geokit'
gem 'google-v3-geocoder', '1.0.0'
gem 'geokit-rails'
# gem 'places'
# gem 'google_places', git: "https://github.com/qpowell/google_places.git"
gem 'google_places_autocomplete', '~> 0.0.3'

# ruby '2.2.1'


