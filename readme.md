
it was build on rails-api gem, but another dev said he wants to use rails-admin for admin frontend and I changed it to full rails engine. can be switched back if you'll use something else.
for authorization I used https://github.com/lynndylanhurley/devise_token_auth.
there is an angular plugin for a smooth integration with that gem and a jquery library, you can choose either.



to run rspecs successully:

	redis-server --daemonize yes 



to see docs:

	rake docs:generate 
	rails server
	and go to http://localhost:3000/api/docs






