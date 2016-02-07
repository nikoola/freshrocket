FactoryGirl.define do
	factory :setting do

		tax_in_percentage       5.00
		free_delivery_order_sum 100
		default_delivery_cost   200
	end
end
