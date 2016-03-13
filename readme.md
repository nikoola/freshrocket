

for authoentication I used https://github.com/lynndylanhurley/devise_token_auth.  
there is an angular plugin for a smooth integration with that gem and a jquery library, you can choose either.

authorization is role-based. sign up is common for clients and admins.  
client becomes an admin when we add ability to it. for example, if we update
`https://rivo.herokuapp.com/api/docs/admin:_users/update_user_abilities` put client with 'products' ability, they'll be able to manage products on backend.

you can see explanations for some of my decisions in the */why* folder.



### to run rspecs successully:


ask me for .env file with passwords etc

	redis-server --daemonize yes



### to see docs:

* just go see: rivo.herokuapp.com/api/docs 

OR

* or generate your own:

	rake docs:generate
	rails server
and go to http://localhost:3000/api/docs




### for rails developer:

	rails g serializer delivery #use `spring stop` if stuck
___

always add user ability through user.add_ability 'orders' to run callbacks.
___

to check out how emails look, I'm using **letter_opener** gem.  
in [dev mode] console

    order = FactoryGirl.create :order
    ClientMailer.order_summary(order).deliver_now
    
will create html file in *Rails.root/tmp/letter_opener* and open it in your browser.  
you'll be able to see pdf attachments there too and click on them.









---

https://jbt.github.io/markdown-editor (great for github markdown generation)



TODO:

	maybe change aato to rolify. it supports proper callbacks.


