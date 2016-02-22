FactoryGirl.define do
	factory :delivery_boy do

		lat '23432'
		long '432432'
		status 'available'
		association :user


	end
end
