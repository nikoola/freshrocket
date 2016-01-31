require 'rails_helper'


describe Order, type: :model do

	before(:each) do
		@user = FactoryGirl.create :user
		@product = FactoryGirl.create :product, price: 1.00
		@product_2 = FactoryGirl.create :product, price: 20.0

		@order = FactoryGirl.create :order #created 3 line items
	end


	it '.set_fixed_price' do
		order = @user.orders.create({ line_items_attributes: [{product_id: @product.id, amount: 2}, {product_id: @product_2.id, amount: 3}] })

		expect(order).to be_valid
		expect(order.fixed_price).to eq(62.0)
	end


	it 'fixed price updated on update' do
		line_item_id = @order.line_items.first.id
		@order.update({line_items_attributes: {id: line_item_id, amount: 10}})

		sum = @order.line_items.map(&:set_fixed_price).reduce {|sum, n| sum + n}
		expect(@order.fixed_price).to eq(sum)
	end


end



