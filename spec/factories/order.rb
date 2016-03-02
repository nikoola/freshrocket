FactoryGirl.define do

	factory :order do
		association  :user

		
		before(:create) do |order|
			city = FactoryGirl.create :city
			order.line_items = create_list(:line_item, 3, order: order)

			order.line_items.each do |li|
				li.product.city_id = city.id
				li.product.save!
			end

			order.address = FactoryGirl.create :address, city_id: city.id
		end


	end



end
