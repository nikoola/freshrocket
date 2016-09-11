require 'rails_helper'

resource 'admin: delivery boys', type: :request do

	let(:prohibited_user) { FactoryGirl.create :user, abilities: [:categories] }
	let(:prohibited_auth_headers) { prohibited_user.create_new_auth_token }

	let(:user) { FactoryGirl.create :user, abilities: [:users] }
	let(:auth_headers) { user.create_new_auth_token }

	include_context 'shared_headers'


	get '/admin/delivery_boys' do
		parameter :statuss, "[unavailable available busy fired]"
		parameter :limit
		parameter :offset


		it 'nonauthenticated - 401', document: false do
			get '/admin/delivery_boys'
			expect_status 401
		end

		it 'authenticated :client user - 401', document: false do
			get '/admin/delivery_boys', {}, prohibited_auth_headers
			expect_status 401
		end

		example 'get filtered delivery_boys' do
			explanation "to change delivery_boy's status to :fired, remove :delivery_boy ability from this user's abilities"

			u = FactoryGirl.create :user
			u.add_ability 'delivery_boy'
			u.remove_ability 'delivery_boy'
			u.save

			a = FactoryGirl.create :user
			a.add_ability 'users'
			a.save #additional user to test filters

			address = FactoryGirl.create :address, user_id: a.id

			do_request({ status: 'fired', city_id: address.city_id })

			returned_ids = jsons.pluck(:id)
			expected_ids = DeliveryBoy.where(status: 'fired').pluck(:id)

			expect(status).to eq(200)
			expect(returned_ids).to match_array(expected_ids)
		end

	end







end








