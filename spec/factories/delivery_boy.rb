FactoryGirl.define do
	factory :delivery_boy do

		lat '23432'
		long '432432'
		status 'available'
		association :user


	end
end

# line item can't exist without order, we never create it by itself.
# only used in order factory.