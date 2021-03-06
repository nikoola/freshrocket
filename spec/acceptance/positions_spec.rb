require 'rails_helper'

resource 'deliver: positions', type: :request do
	let(:user)         { FactoryGirl.create :user, abilities: ['delivery_boy'] }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'

	let(:order) { FactoryGirl.create :order, delivery_boy: user.delivery_boy }


	get '/orders/:id/positions' do

		example 'get a map trace for some order' do
			explanation "available for delivery_boy's order, own client's order, or for user with orders ability"
			do_request({
				id: order.id
			})

			expect(json[:positions]).to be_an Array
		end



	end





end
