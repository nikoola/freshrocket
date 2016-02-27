FactoryGirl.define do

	factory :order do
		association  :user
		association  :address
		
		payment_type 'cash'

		before(:create) do |order|
			order.line_items = create_list(:line_item, 3, order: order)
		end
	end



end
