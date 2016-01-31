FactoryGirl.define do
	factory :line_item do

		amount          3
		association :product

	end
end

# line item can't exist without order, we never create it by itself.
# only used in order factory.