require 'rails_helper'


describe Order, type: :model do

	let(:user){ FactoryGirl.create :user }
	let(:product){ FactoryGirl.create :product, price: 1.00 }
	let(:product_2){ FactoryGirl.create :product, price: 20.0 }
	let(:order){ FactoryGirl.create :order } #created 3 line items


	describe 'fix line item and product prices' do
		it '.set_fixed_price' do
			order = user.orders.create({ 
				line_items_attributes: [
					{product_id: product.id, amount: 2}, 
					{product_id: product_2.id, amount: 3}
				] 
			})

			expect(order).to be_valid
			expect(order.fixed_price).to eq(62.0)
		end

		it 'fixed price updated on order update' do
			order.update({
				line_items_attributes: [
					{id: order.line_items.first.id, amount: 10}
				]
			})

			order_price = 0
			order.line_items.each do |line_item|
				line_item_price = line_item.product.price * line_item.amount
				order_price += line_item_price
			end

			expect(order.fixed_price).to eq(order_price)
		end

		it 'fixed price not updated on product price change' do
			initial_price = order.fixed_price
			order.line_items.first.product.update(price: 12)

			expect(initial_price).to eq(order.reload.fixed_price)
		end
	end

	describe 'aasm' do
		it 'confirm: changes inventory count' do
			line_item = order.line_items.first
			line_item.update(amount: 5)

			product = line_item.product
			product.update(inventory_count: 1)


			expect(order.confirm!).to eq(false)

			parsed_errors = JSON.parse order.errors.to_json
			expect(parsed_errors['products']).to include("product.inventory_count" => 1, "line_item.amount" => 5, "product.id" => product.id)

			expect(product.reload.inventory_count).to eq(1)

		end
	end


end



