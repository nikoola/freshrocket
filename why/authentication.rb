

___why token-based?
	'https://scotch.io/tutorials/the-ins-and-outs-of-token-based-authentication'
	and because session-based authentication is unavailable on mobile.


client-side will keep access_token at localstorage
The authentication information should be included by the client in the headers of each request.


___why are the new routes included if this gem doesnt use them? #https://github.com/lynndylanhurley/devise_token_auth#why-are-the-new-routes-included-if-this-gem-doesnt-use-them

Removing the new routes will require significant modifications to devise. If the inclusion of the new routes is causing your app any problems, post an issue in the issue tracker and it will be addressed ASAP.


___how to set up angular + rails?
	'https://www.airpair.com/ruby-on-rails/posts/authentication-with-angularjs-and-ruby-on-rails'

___why invalid_grant?
	# [1] pry(#<RSpec::ExampleGroups::Users::GETOrders>)> json_body
	# => {:error=>"invalid_grant"}
	# --- if we give him invalid Login info on post '/token'


