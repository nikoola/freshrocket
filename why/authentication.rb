

___why token-based?
	'https://scotch.io/tutorials/the-ins-and-outs-of-token-based-authentication'
	and because session-based authentication is unavailable on mobile.


client-side will keep access_token at localstorage

change auth to 'https://github.com/lynndylanhurley/devise_token_auth' for security? 
you would usually store the token in localStorage or so if your client is a browser.

___how to set up angular + rails?
	'https://www.airpair.com/ruby-on-rails/posts/authentication-with-angularjs-and-ruby-on-rails'

___why invalid_grant?
	# [1] pry(#<RSpec::ExampleGroups::Users::GETOrders>)> json_body
	# => {:error=>"invalid_grant"}
	# --- if we give him invalid Login info on post '/token'


