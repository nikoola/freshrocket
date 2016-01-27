require 'rails_helper'


describe Order, type: :model do


	it 'should return true if there is a shipment_id' do
		order = Order.create({  line_items_attributes: 
			[{product_id: 1, amount: 2}, {product_id: 2, amount: 3}]  
		})

		expect(order.line_items.pluck(:amount)).to eq([2, 3])
	end


end



