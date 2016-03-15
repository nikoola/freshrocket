require 'rails_helper'

resource 'deliver: orders/1/positions', type: :request do
	let(:user)         { FactoryGirl.create :user, abilities: ['delivery_boy'] }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'

	let(:order) { FactoryGirl.create :order, delivery_boy: user.delivery_boy }

	post '/deliver/orders/:id/positions' do

		with_options required: true do
			parameter :position
		end


		example 'mark new position' do
			position = "42.10808340000001,87.735895"

			do_request({
				id:       order.id,
				position: position
			})

			expect(redis.lrange("deliveries:#{order.id}", 0, 0)[0]).to eq(position)
		end
	end







end
