FactoryGirl.define do
	factory :delivery do

		wanted_date Time.now
		wanted_time 'morning'
		association :order
		association :user #delivery_boy

	end
end

# line item can't exist without order, we never create it by itself.
# only used in order factory.