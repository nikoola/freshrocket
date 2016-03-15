require 'rails_helper'

resource 'deliver: delivery boys', type: :request do
	let(:user) { FactoryGirl.create :user, abilities: ['delivery_boy'] }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'

	put '/deliver/delivery_boy' do

		with_options scope: :delivery_boy do
			parameter :statuss, 'unavailable/available/busy/fired'
			parameter :current_order_id, "delivery boy may have multiple nondelivered orders in the same time. current_order_id is the order she's currently delivering"
		end


		example 'update self' do
			order = FactoryGirl.create :order

			do_request({
				delivery_boy: {
					current_order_id: order.id
				}
			})

			expect(user.delivery_boy.current_order.id).to eq order.id
		end
	end





end
