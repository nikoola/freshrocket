require 'rails_helper'

resource 'Settings', type: :request do

	let(:prohibited_user) { FactoryGirl.create :user, abilities: [:categories, :users] }
	let(:prohibited_auth_headers) { prohibited_user.create_new_auth_token }

	let(:user) { FactoryGirl.create :user, abilities: [:settings] }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'


	get '/admin/settings' do
		it 'nonauthenticated - 401', document: false do
			get path
			expect_status 401
		end

		it 'authenticated non :settings user - 401', document: false do
			get path, {}, prohibited_auth_headers
			expect_status 401
		end


		example 'authenticated :settings user - 200', document: false do
			do_request

			expect(status).to eq(200)
			expect(json.keys).to match_array([:id, :tax_in_percentage, :free_delivery_order_sum, :default_delivery_cost])
		end
	end

	put '/admin/settings' do

		with_options scope: :settings do
			parameter :tax_in_percentage,       'order cost = products cost + products cost * tax'
			parameter :free_delivery_order_sum, 'after this order sum, delivery is free'
			parameter :default_delivery_cost,   "delivery costs this much if order doesn't sum up to more than :free_delivery_order_sum"
		end

		example 'update settings' do
			do_request(settings: { 
				tax_in_percentage: 99.0, 
				default_delivery_cost: 115
			})

			expect(status).to eq(200)

			expect(Setting.instance.tax_in_percentage).to eq(99)
			expect(Setting.instance.default_delivery_cost).to eq(115)
		end

		example 'update settings: invalid params' do
			initial_value = Setting.instance.default_delivery_cost 

			do_request(settings: { 
				tax_in_percentage: 150, 
				default_delivery_cost: 120
			})

			expect(status).to eq(422)
			expect(json[:tax_in_percentage]).to include("must be less than or equal to 100")
			
			expect(Setting.instance.default_delivery_cost).to eq(initial_value)
		end



	end



end








