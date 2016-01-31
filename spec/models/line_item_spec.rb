require 'rails_helper'


describe Order, type: :model do

	before(:each) do
		@order = FactoryGirl.create :order
		@product = FactoryGirl.create :product
	end


	it '.set_fixed_price' do
		product = FactoryGirl.create :product, price: 20

		@order.update line_items_attributes: [{product_id: product.id, amount: 3}]
		line_item = @order.line_items.find_by(product_id: product.id) 
		expect(line_item.fixed_price).to eq(60)
	end

	it 'is destroyed on order destruction' do
		line_items = @order.line_items
		@order.destroy

		expect(line_items).to all( be_destroyed )
	end

	it 'deletes nested line_items on update' do
		previous_line_item_ids = @order.line_items.pluck(:id)
		previous_line_item_ids.each do |line_item_id|
			@order.update(line_items_attributes: [{id: line_item_id, _destroy: true}])
		end

		@order.update({ 
			comment: 'hi', 
			line_items_attributes: [{ product_id: @product.id, amount: 200 }] 
		})

		expect(@order.line_items.count).to eq(1)
	end



end



