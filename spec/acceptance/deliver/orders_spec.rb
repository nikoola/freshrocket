require 'rails_helper'

resource 'Orders', type: :request do
	let(:user) { FactoryGirl.create :user }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'



	get 'deliver/orders' do
		parameter :statuss, '[dispatched, delivered]'

		example "get current delivery_boy's orders" do
			user.add_ability 'delivery_boy'
			user.delivery_boy.orders = FactoryGirl.create_list :order, 5
			user.save

			do_request

			returned_ids = jsons.pluck(:id)
			expected_ids = user.delivery_boy.orders.pluck(:id)

			expect(status).to eq(200)
			expect(returned_ids).to match_array(expected_ids)
		end

	end

	put 'deliver/orders/:id/update_status' do
		parameter :action, '[delivered]', scope: :order

		example "update status of delivery_boy's order" do
			explanation 'delivery_boy can only update it to delivered'
			user.add_ability 'delivery_boy'
			user.delivery_boy.orders = FactoryGirl.create_list :order, 5
			user.save

			user_order = user.delivery_boy.orders.first
			user_order.confirm!
			user_order.approve!
			user_order.dispatch!

			do_request(id: user_order.id, order: { action: 'deliver' } )

			expect(status).to eq(200)
			expect(user_order.reload.status).to eq('delivered')
		end

	end













end
