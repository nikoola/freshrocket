FactoryGirl.define do
	factory :user do
		email                 'hi@hi.com'
		password              'secrety_bickety'
		password_confirmation 'secrety_bickety'

		phone                 '+79173332221'
		role                  :client
	end
end
