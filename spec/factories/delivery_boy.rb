FactoryGirl.define do
	factory :delivery_boy do

		status 'available'
		association :user
		

	end
end
