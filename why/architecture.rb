




___why not STI for User?
	DeliveryBoy < User
	Admin < User
	Client < User
	isnt worth it for now, but consider it as difference grows if it does.
	'http://stackoverflow.com/a/14015942/3192470'


Basically we have :user that can have any role. 
:user is always a client, and she may have privileges of admins (eg access to products and/or orders, etc).
:user in addition to being an admin can be appointed delivery_boy. in this case, apart from :user having a :delivery_boy ability (which allows access to /deliver subroutes), :user will be able to create and update :delivery_boy record which belongs_to her :user profile. she can mention her status (:delivering/:available/:holiday) and location there (in :delivery_boy record) too.
if :user is fired from :delivery_boy position (no :delivery_boy ability anymore), her :delivery_boy status changes to :fired.





___heroku-specific things
	You can’t write to local disk (no log files, no file-based Rails cache), nor assume that things like global variables will last from request to request.


___why we repeat addresses/orders/users resource functionality in /admin and /client?
	it's a legacy code decision, didn't know they'd require me user creation and etc on the backend, functionality used to differ a lot.




