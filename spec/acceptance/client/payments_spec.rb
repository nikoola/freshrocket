require 'rails_helper'

resource 'Payments', type: :request do

	let(:user) { FactoryGirl.create :verified_user }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'

	get '/client/payments/new' do
		parameter 'order_id'
		parameter 'amount'

		example 'return all forms for payment' do
			do_request

			expect(json[:citrus][:fields]).to include(orderAmount: "10")
		end


	end










end
