FactoryGirl.define do

	factory :order do
		association  :user

		
		before(:create) do |order|
			city = FactoryGirl.create :city
			area = FactoryGirl.create :area, city_id: city.id
			order.line_items = create_list(:line_item, 3, order: order)

			order.line_items.each do |li|
				li.product.city_id = city.id
				li.product.save!
			end

			order.address = FactoryGirl.create :address, area: area # use object instead of area_id because evaluator create area object in spite of area_id id given
		end


	end



end
