require 'rails_helper'


describe Order, type: :model do

	let(:user){ FactoryGirl.create :user }


	describe 'fix line item and product prices' do
		let(:product){ FactoryGirl.create :product, price: 1.00 }
		let(:product_2){ FactoryGirl.create :product, price: 20.0 }
		let(:order){ FactoryGirl.create :order } #created 3 line items

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
		let(:product_1){ FactoryGirl.create :product, inventory_count: 0 }
		let(:product_2){ FactoryGirl.create :product, inventory_count: 3 }
		let(:product_3){ FactoryGirl.create :product, inventory_count: 10 }

		let(:order) do 
			Order.create({
				user_id: user.id,
				line_items_attributes: [
					{ product_id: product_1.id, amount: 5 },
					{ product_id: product_2.id, amount: 10 },
					{ product_id: product_3.id, amount: 2 }
				]
			}) 
		end
		let(:id_1){ order.line_items.find_by(product_id: product_1.id).id }
		let(:id_2){ order.line_items.find_by(product_id: product_2.id).id } #line item ids

		describe 'confirm!' do
			it 'changes inventory count: failure' do
				expect(order.confirm!).to be(nil) #unsuccessful, since :after transaction failed witk ROLLBACK 

				parsed_errors = JSON.parse order.errors.to_json

				expect(parsed_errors['stock shortage']).to match_array([
					{"product.inventory_count"=>0, "line_item.amount"=>5, "product.id"=>product_1.id, "line_item.id"=>id_1}, 
					{"product.inventory_count"=>3, "line_item.amount"=>10, "product.id"=>product_2.id, "line_item.id"=>id_2}
				])

				expect(product_1.reload.inventory_count).to eq(0)
				expect(product_2.reload.inventory_count).to eq(3)
				expect(product_3.reload.inventory_count).to eq(10) #even successful stock decrease rollbacks
			end

			it 'changes inventory count: success' do
				order.update({
					line_items_attributes: [
						{id: id_1, _destroy: true},
						{id: id_2, _destroy: true}
					]
				})

				expect(order.confirm!).to be(true)

				expect(product_1.reload.inventory_count).to eq(0) 
				expect(product_2.reload.inventory_count).to eq(3) #not changed since they were deleted
				expect(product_3.reload.inventory_count).to eq(8) #10-2, stock decreased!
			end
		end

		describe 'cancel!' do
			it 'increases inventory count' do
				order.update({
					line_items_attributes: [
						{ id: id_1, _destroy: true },
						{ id: id_2, amount: 3 }
					]
				})

				expect(order.confirm!).to be(true)
				expect(product_1.reload.inventory_count).to eq(0) #not present in order
				expect(product_2.reload.inventory_count).to eq(0) #3-3
				expect(product_3.reload.inventory_count).to eq(8) #10-2

				expect(order.cancel!).to be(true)
				expect(product_1.reload.inventory_count).to eq(0) #not present in order
				expect(product_2.reload.inventory_count).to eq(3) #0+3
				expect(product_3.reload.inventory_count).to eq(10) #8+2
			end
		end


	end


end



