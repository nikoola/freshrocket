require 'rails_helper'

resource 'admin: orders', type: :request do

	# let(:prohibited_user) { FactoryGirl.create :user, abilities: [:categories] }
	# let(:prohibited_auth_headers) { prohibited_user.create_new_auth_token }

	let(:user) { FactoryGirl.create :user, abilities: [:orders] }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'

	let(:order) { FactoryGirl.create :order }

	get '/admin/orders' do
		parameter :limit,  'amount of orders to get'
		parameter :offset
		parameter :status_, 'status. only get [unconfirmed, confirmed, approved, dispatched, delivered, canceled] orders'
		parameter :user_id
		parameter :city_id, 'returns orders which have addresses in this city'
		parameter :include_, 'line_items, address, delivery_boy - whether to include association'

		it 'nonauthenticated - 401', document: false do
			get '/admin/orders'
			expect_status 401
		end

		it 'authenticated :client user - 401', document: false do
			get '/admin/orders', {}, @auth_headers
			expect_status 401
		end

		example 'get all orders', document: false do
			do_request

			returned_ids = jsons.pluck(:id)
			expected_ids = Order.pluck(:id)

			expect(status).to eq(200)
			expect(returned_ids).to match_array(expected_ids)
		end

		example 'get filtered orders' do
			FactoryGirl.create_list :order, 6

			do_request city_id: Order.first.address.city_id, limit: 5, offset: 2, 
				include: ['delivery_boy']

			# fail because of no city_id specified expect[json].to be_nil
			expect[jsons].not_to be_nil
			# returned_ids = jsons.pluck(:id)
			# expected_ids = Order.limit(5).offset(2).pluck(:id)

			# expect(status).to eq(200)
			# expect(returned_ids).to match_array(expected_ids)
			# expect(jsons[0].keys).not_to include :address, :line_items
			# expect(jsons[0].keys).to     include :delivery_boy
		end

	end

	get '/admin/orders/:id' do
		parameter :include, 'line_items, address - whether to include association'

		it 'nonauthenticated - 401', document: false do
			get admin_order_path(order)
			expect_status 401
		end

		it 'authenticated :client user - 401', document: false do
			get admin_order_path(order), {}, @auth_headers
			expect_status 401
		end

		it 'get order' do
			explanation 'user with :order ability can get any order'
			do_request({
				id:      order.id,
				include: ['address']
			})



			expect(status).to eq(200)
			expect(json.keys).to include(
				:id,
				:user_id,
				:status,
				:created_at,
				:comment, :admin_comment,
				:pure_product_price,
				:tax,
				:delivery_charge,
				:total_price
			)
			expect(json.keys).to     include :address
			expect(json.keys).not_to include :line_items
		end
	end

	post '/admin/orders' do
		with_options :scope => :order do
			parameter :comment,     'comment to the order'
			parameter :address_id,  '', required: true
			parameter :feedback
			parameter :source_type, "['web', 'phone', 'mobile']"
			parameter :coupon_code
			parameter :wanted_date, 'date client wants their delivery on'
			parameter :wanted_time, "['morning', 'noon', 'evening'] time is limited between 7 am to 9 pm only, mention this in frontend"
			parameter :delivery_boy_id
		end

		with_options :scope => [:order, :line_items_attributes], :required => true do
			parameter :product_id, 'id of a product in a cart'
			parameter :amount, 'amount of this product in a cart'
		end

		example 'create order' do
			explanation 'confirm and approve right after'

			attributes = FactoryGirl.attributes_for(:order).merge( 
				address_id: FactoryGirl.create(:address).id,
				user_id:    FactoryGirl.create(:user).id,
				line_items_attributes: [
					{
						product_id: FactoryGirl.create(:product).id, amount: 3
					}
				]
			)

			do_request order: attributes
			
			order = Order.find(json[:id])

			expect(status).to eq(201)
			expect(order.payment_type).to eq('cash')
		end

	end

	put '/admin/orders/:id' do

		it 'update order' do
			delivery_boy = FactoryGirl.create :delivery_boy
			do_request id: order.id, order: { delivery_boy_id: delivery_boy.id }
			
			expect(status).to eq(200)
			expect(order.reload.delivery_boy.id).to eq(delivery_boy.id)
		end
	end


	put '/admin/orders/:id/update_status' do
		parameter :action, ':approve, :dispatch, :deliver, :cancel', scope: :order, required: true

		example 'approve confirmed order' do
			order.confirm!

			do_request({ id: order.id, order: {action: 'approve'} })

			expect(status).to eq(200)
			expect(order.reload.status).to eq('approved')
		end

		it 'admin cant confirm order she doesnt own', document: false do
			put "/admin/orders/#{order.id}/update_status", {order: {action: 'confirm'}}, auth_headers
			expect_status 401
			expect_json :error=>"this user can't confirm order"
		end

		it 'updates approved to dispatched', document: false do
			order.confirm!
			order.approve!

			order.delivery_boy = FactoryGirl.create :delivery_boy
			order.save

			put "/admin/orders/#{order.id}/update_status", {order: {action: 'dispatch'}}, auth_headers
			expect_status 200
			expect(order.reload.status).to eq('dispatched')
		end

		it 'cant update to dispatched if delivery has no delivery_boy' do
			order.confirm!
			order.approve!

			do_request({ id: order.id, order: {action: 'dispatch'} })

			expect(status).to eq(422)
			expect(order.reload.status).to eq('approved')
			expect(json).to include({:order=>["needs to be assigned to some delivery boy before dispatching"], :status=>["status cannot transition from approved to dispatch"]})
		end


	end



end
