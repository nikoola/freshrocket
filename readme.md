
it was built on rails-api gem, but another dev said he wants to use rails-admin for admin frontend and I changed it to full rails engine. can be switched back if you'll use something else.
for authorization I used https://github.com/lynndylanhurley/devise_token_auth.
there is an angular plugin for a smooth integration with that gem and a jquery library, you can choose either.



to run rspecs successully:

	ask me for yml files with passwords etc
	redis-server --daemonize yes

to run things in console/deloyment successfully:

	ask me for yml files with passwords etc
	redis-server --daemonize yes
	sidekiq

	
	heroku run rake db:migrate



to see docs:

	rake docs:generate 
	rails server
	and go to http://localhost:3000/api/docs


for rails developer:

	rails g serializer delivery #use `spring stop` if stuck

	always add user ability through user.add_ability 'orders' to run callbacks.

	if 401, return json in the form of error: 'all bad'.
	if 422, {base: ['bad'], order: ['worse']}

TODO:

	maybe change aato to rolify. it supports proper callbacks,


