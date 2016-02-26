require 'rails_helper'

resource 'deliver: delivery boys', type: :request do
	let(:user) { FactoryGirl.create :user }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'

	put '/deliver/delivery_boy' do

		with_options scope: :delivery_boy do
			parameter :lat
			parameter :long
			parameter :statuss
		end


		example 'update self' do
			user.add_ability 'delivery_boy'
			do_request({
				delivery_boy: {
					lat: '3278789789'
				}
			})

			expect(status).to eq(200)
			expect(user.reload.delivery_boy.lat).to eq('3278789789')
		end
	end





end
