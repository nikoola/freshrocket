require 'rails_helper'

resource 'Orders', type: :request do

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
		parameter :city_id
		parameter :user_id

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
			# FactoryGirl.create_list :order, 6, status: 'confirmed'
			# FactoryGirl.create_list :order, 2, status: 'delivered'

			do_request limit: 5, offset: 2, status: 'confirmed'

			returned_ids = jsons.pluck(:id)
			expected_ids = Order.limit(5).offset(2).where(status: 'confirmed').pluck(:id)

			expect(status).to eq(200)
			expect(returned_ids).to match_array(expected_ids)
		end

	end

	get '/admin/orders/:id' do
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
			do_request({id: order.id})
			
			expect(status).to eq(200)
			expect(json.keys).to include(
				:id,
				:user_id,
				:status,
				:created_at,
				:comment,
				:pure_product_price,
				:tax,
				:delivery_charge,
				:total_price,
				:line_items
			)
		end
	end

	# post '/admin/orders' do


	# 	it 'by admin, with invalid params: errors returned' do
	# 		post '/admin/orders', {order: FactoryGirl.attributes_for(:order, phone: nil)} , @admin_user_auth_headers
	# 		expect_status 422
	# 		expect_json :user=>["can't be blank"], :order=>["must add at least one line item"]
	# 	end

	# end

	# describe 'PUT admin/orders/1' do
	# 	it 'by admin, with valid params: user updated' do
	# 		put admin_order_path(@order), {order: {role: :admin}}, @admin_user_auth_headers

	# 		expect_status 200
	# 		expect_json_keys [:status, :comment]
	# 	end
	# end

	# describe 'DELETE admin/orders/1' do
	# 	it 'by admin: user deleted' do
	# 		delete admin_order_path(@order), {}, @admin_user_auth_headers
	# 		expect_status 200
	# 	end
	# end

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

			put "/admin/orders/#{order.id}/update_status", {order: {action: 'dispatch'}}, auth_headers
			expect_status 200
			expect(order.reload.status).to eq('dispatched')
		end


	end



end
