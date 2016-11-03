require 'rails_helper'

resource 'client: payments', type: :request do

	let(:user) { FactoryGirl.create :verified_user }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'

	get '/client/payments/new' do
		parameter :order_id, 'unique id'

		example 'return all forms for payment for own order' do
			order = FactoryGirl.create :order, user_id: user.id
			do_request(order_id: order.id)

			# expect(json[:citrus][:fields][:orderAmount]).to eq(order.total_price.to_s) 
			# expect(json[:citrus][:fields].keys).to match_array([:merchantTxnId, :merchantAccessKey, :orderAmount, :currency, :secret_key, :pmt_url, :returnUrl, :paymentMode, :reqtime, :secSignature])
			# secSignature was generated server-side, and will be checked on notification.acknowledge


			p json[:paytm]

			# expect(json[:paytm][:fields][:orderAmount]).to eq(order.total_price.to_s) 
			# expect(json[:paytm][:fields].keys).to match_array([:merchantTxnId, :merchantAccessKey, :orderAmount, :currency, :secret_key, :pmt_url, :returnUrl, :paymentMode, :reqtime, :secSignature])
		end


  end

	get '/client/payments/discount' do
		parameter :cupon_code, '', required: true
		example_request "return coupon code if exist" do
			coupon = FactoryGirl.create :coupon

			do_request cupon_code: coupon.code

			expect(json).to include :id, :name, :code, :discount
			expect(status).to eq(200)
		end
	end

end
