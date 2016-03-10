Rails.application.config.middleware.use OmniAuth::Builder do

	provider :facebook, 
		ENV['omniauth.facebook.key'], ENV['omniauth.facebook.secret'],
		info_fields: 'email,first_name,last_name'

end




