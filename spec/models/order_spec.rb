require 'rails_helper'


describe Order, type: :model do

	let(:user){ FactoryGirl.create :user }


	describe 'pricing' do
		let(:product){ FactoryGirl.create :product, price: 1.00 }
		let(:product_2){ FactoryGirl.create :product, price: 20.0 }
		let(:order){ FactoryGirl.create :order } #created 3 line items

		it '.set_order_pricing' do
			order = user.orders.create({ 
				line_items_attributes: [
					{product_id: product.id, amount: 2}, 
					{product_id: product_2.id, amount: 3}
				] 
			})

			expect(order).to be_valid
			expect(order.pure_product_price).to eq(62.0)

			tax = 62.0 * (Setting.s.tax_in_percentage / 100)

			expect(order.tax).to eq(tax)
			expect(order.delivery_charge).to eq(Setting.s.default_delivery_cost)
			expect(order.total_price).to eq(62.0 + order.tax + order.delivery_charge )
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

			expect(order.pure_product_price).to eq(order_price)
		end

		it 'fixed price not updated on product price change' do
			initial_price = order.pure_product_price
			order.line_items.first.product.update(price: 12)

			expect(initial_price).to eq(order.reload.pure_product_price)
		end

		describe 'coupon code' do
			it 'adds error when invalid' do
				order = user.orders.create({
					coupon_code: 'nonexistent code',
					line_items_attributes: [
						{ product_id: product.id,   amount: 2 }, 
						{ product_id: product_2.id, amount: 3 }
					] 
				})

				expect(order.errors.messages).to include(:coupon_code=>["there is no such coupon"])
			end

			it 'changes price when valid' do
				coupon = FactoryGirl.create :coupon
				order = user.orders.create({
					coupon_code: coupon.code,
					line_items_attributes: [
						{ product_id: product.id, amount: 20 }
					]
				})

				expect(order).to be_valid

				pure            = product.price * 20
				delivery        = pure > Setting.s.free_delivery_order_sum ? 0 : Setting.s.default_delivery_cost
				tax             = pure * ( Setting.s.tax_in_percentage / 100.0 )
				coupon_discount = pure * ( coupon.discount / 100.0 )
				total = pure + delivery + tax - coupon_discount

				expect(order.pure_product_price).to eq(pure)
				expect(order.delivery_charge).to eq(delivery)
				expect(order.tax).to eq(tax)
				expect(order.coupon_discount).to eq(coupon_discount)
				expect(order.total_price).to eq(total)
			end

			it 'ignores when blank' do
				coupon = FactoryGirl.create :coupon

				order = user.orders.create({
					coupon_code: coupon.code,
					line_items_attributes: [
						{ product_id: product.id, amount: 20 }
					]
				})

				expect(order.coupon_discount.to_i).to be > 0

				order.update(coupon_code: '')

				expect(order).to be_valid
				expect(order.coupon_discount.to_i).to eq(0)
			end


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

		describe 'dispatch!' do
			it 'fails if no delivery_boy' do
				order = FactoryGirl.create :order
				order.confirm!
				order.approve!

				expect(order.dispatch!).to be(false)
				expect(order.status).to eq('approved')
				expect(order.errors.messages).to include(order: ["needs to be assigned to some delivery boy before dispatching"])
			end
		end



	end





end



