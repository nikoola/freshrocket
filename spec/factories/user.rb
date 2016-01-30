FactoryGirl.define do

	factory :user do
		sequence(:email)       { |i| "hi_#{i}@hi.com" }
		password              'secrety_bickety'
		password_confirmation 'secrety_bickety'

		phone                 '+79173332221'
		role                  :client

		factory :admin_user do
		  role                :admin
		end

	end
end
